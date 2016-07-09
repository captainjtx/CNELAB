#include <mex.h>
#include <iostream>

#include <pthread.h>
using namespace std;

#ifdef _WIN32
#include <windows.h>
#elif MACOS
#include <sys/param.h>
#include <sys/sysctl.h>
#else
#include <unistd.h>
#endif
 
struct fparam {
  double* b;
  double* a;
  int nb;
  int na;    
} ;


int getNumberOfCores() {
#ifdef WIN32
    SYSTEM_INFO sysinfo;
    GetSystemInfo(&sysinfo);
    return sysinfo.dwNumberOfProcessors;
#elif MACOS
    int nm[2];
    size_t len = 4;
    uint32_t count;
 
    nm[0] = CTL_HW; nm[1] = HW_AVAILCPU;
    sysctl(nm, 2, &count, &len, NULL, 0);
 
    if(count < 1) {
    nm[1] = HW_NCPU;
    sysctl(nm, 2, &count, &len, NULL, 0);
    if(count < 1) { count = 1; }
    }
    return count;
#else
    return sysconf(_SC_NPROCESSORS_ONLN);
#endif
}

#define MIN(a, b) (((a) < (b)) ? (a) : (b))
#define MAX(a, b) (((a) > (b)) ? (a) : (b))

//global variable
pthread_mutex_t chan_mutex;
// pthread_mutex_t cout_mutex;

pthread_attr_t attr;  

const mxArray *b;
const mxArray *a;

unsigned int threadNum;

fparam* filterConfig;

void *threadfunc(void *arg) {
    void **args=(void **) arg;
    
    double* data=(double*)args[0];
    int sample=*((int* )args[1]);
    int padding=*((int* )args[2]);
    int* chancount=(int*)args[3];
    
    int chan=*((int* )args[4]);

    double* output=(double*)args[5];
    
    double* y=new double [sample+2*padding];
    double* ry=new double [sample+2*padding];
    double* x=new double [sample+padding];
    int ichan;
    
    int ib_n;
    int ia_n;
    double* ia_e;
    double* ib_e;
    
    pthread_mutex_lock(&chan_mutex);
    ichan=++(*chancount);//atomic
    pthread_mutex_unlock(&chan_mutex);
        
    while(ichan<chan)
    {

        ia_e=filterConfig[ichan].a;
        ib_e=filterConfig[ichan].b;
        ia_n=filterConfig[ichan].na;
        ib_n=filterConfig[ichan].nb;
        
        for(int k=0;k<padding;++k)
        {
            x[k]=0;
        }
        for(int k=padding;k<sample+padding;++k)
        {
            x[k]=data[ichan*sample+k-padding];
        }
        
        for(int k=0;k<sample+2*padding;++k)
        {
            y[k]=0;
        }
        
        //filter forward
        for (int j=padding;j<sample+padding;++j)
        {
            for(int m=0;m<ib_n;++m)
            {
                y[j]+=ib_e[m]*x[j-m];
            }
            for(int m=1;m<ia_n;++m)
            {
                y[j]-=ia_e[m]*y[j-m];
            }
            y[j]/=ia_e[0];
        }
        //filter backward
        for(int k=0;k<sample+2*padding;++k)
        {
            ry[k]=y[sample+2*padding-1-k];
        }
        
        for(int k=0;k<sample+2*padding;++k)
        {
            y[k]=0;
        }
        
        for (int j=padding;j<sample+padding;++j)
        {
            for(int m=0;m<ib_n;++m)
            {
                y[j]+=ib_e[m]*ry[j-m];
            }
            for(int m=1;m<ia_n;++m)
            {
                y[j]-=ia_e[m]*y[j-m];
            }
            y[j]/=ia_e[0];
        }
        
        for (int j=padding;j<sample+padding;++j)
        {
            output[ichan*sample+j-padding]=y[sample+2*padding-1-j];
        }
        
        pthread_mutex_lock(&chan_mutex);
        ichan=++(*chancount);//atomic
        pthread_mutex_unlock(&chan_mutex);
    }
    delete[] y;
    delete[] ry;
    delete[] x;
    
//     pthread_mutex_lock(&cout_mutex);
//     cout<<"Thread complete"<<endl;
//     pthread_mutex_unlock(&cout_mutex);
    
    pthread_exit( NULL );
}

void mexFunction(int nlhs, mxArray *plhs[],
        int nrhs, const mxArray *prhs[])
{
    try
    {
        //the optimal thread number is cpu core number
        threadNum=getNumberOfCores();
    }
    catch (int e)
    {
        //if can not determine core number, using default 8
        threadNum=8;
    }
    
    double* output;
    double* data;
    int nb;
    int na;
    int chan;
    int sample;
    int padding=0;
    void *args[6];
    int chancount[1];
            
    mxArray *ib;
    mxArray *ia;
    double* ib_e;
    double* ia_e;
    int ib_n;
    int ia_n;
    
    pthread_t threads[threadNum];
    pthread_mutex_init(&chan_mutex,NULL);
//     pthread_mutex_init(&cout_mutex,NULL);
    
    pthread_attr_init(&attr);
    pthread_attr_setdetachstate(&attr, PTHREAD_CREATE_JOINABLE);

    void* status;
    
    if (nrhs != 3) {
        mexErrMsgIdAndTxt("MATLAB:Filter:nargin",
                "Requires three input arguments.");
    } else if (nlhs != 1) {
        mexErrMsgIdAndTxt("MATLAB:Filter:nargout",
                "Requires one output argument.");
    }
    
    b = prhs[0];
    a = prhs[1];
    data=mxGetPr(prhs[2]);
    
    const mwSize* bdim = mxGetDimensions(b);
    mwSize bdim_n= mxGetNumberOfDimensions(b);
    
    if (bdim_n != 2) {
        mexErrMsgIdAndTxt("MATLAB:Filter:nargin",
                "Wrong dimension of b");
    }
    else
    {
        nb=MAX(bdim[0],bdim[1]);
    }
    
    const mwSize* adim = mxGetDimensions(a);
    mwSize adim_n= mxGetNumberOfDimensions(a);
    
    
    if (adim_n != 2) {
        mexErrMsgIdAndTxt("MATLAB:Filter:nargin",
                "Wrong dimension of a");
    }
    else
    {
        na=MAX(adim[0],adim[1]);
        
    }
    
    const mwSize* datadim = mxGetDimensions(prhs[2]);
    mwSize datadim_n=mxGetNumberOfDimensions(prhs[2]);
    
    if (datadim_n != 2) {
        mexErrMsgIdAndTxt("MATLAB:Filter:nargin",
                "Wrong dimension of data");
    }
    else
    {
        chan=datadim[1];
        sample=datadim[0];
    }
    
    
    if (na!=nb||na!=chan||nb!=chan)
    {
        mexErrMsgIdAndTxt("MATLAB:Filter:nargin",
                "Unequal number of channels between b,a and size(data,2)");
    }
    else
    {
        plhs[0]=mxCreateDoubleMatrix(sample,chan,mxREAL);
        output=mxGetPr(plhs[0]);
    }
    //mxGetCell cannot be accessed inside thread in windows, maybe not threadsafe
    //So we define our own data structure...
    filterConfig=new fparam[chan];
    
    for(int i=0;i<chan;++i)
    {
        ib= mxGetCell(b,i);
        ia= mxGetCell(a,i);
        
        ib_e=mxGetPr(ib);
        ia_e=mxGetPr(ia);
        
        const int* ib_dim=mxGetDimensions(ib);
        ib_n=MAX(ib_dim[0],ib_dim[1]);
        
        const int* ia_dim=mxGetDimensions(ia);
        ia_n=MAX(ia_dim[0],ia_dim[1]);
        
        filterConfig[i].a=new double[ia_n];
        filterConfig[i].b=new double[ib_n];
        
        filterConfig[i].na=ia_n;
        filterConfig[i].nb=ib_n;
        
        for(int j=0;j<ia_n;++j)
        {filterConfig[i].a[j]=ia_e[j];}
        
        for(int j=0;j<ia_n;++j)
        {filterConfig[i].b[j]=ib_e[j];}
        
        padding=MAX(padding,ib_n);
        padding=MAX(padding,ia_n);
    }
    
//     cout<<x_padding<<" "<<y_padding;
    *chancount=-1;
    
    for (int i=0;i<threadNum;++i)
    {
        args[0]=data;
        args[1]=&sample;
        args[2]=&padding;
        args[3]=chancount;
        args[4]=&chan;
        args[5]=output;
        
        int rc = pthread_create(&threads[i],&attr,threadfunc,args);
        if (rc)
        {
            mexErrMsgIdAndTxt("MATLAB:Filter:pthread_create",
                "Unable to create thread");
            return;
        }
    }
    
    pthread_attr_destroy(&attr);
    
    /* Wait on the other threads */
    for(int i=0; i<threadNum; i++)
    {
        pthread_join(threads[i], &status);
    }
    
    //Strangly block the function from return.
    //pthread_exit(NULL);
    
    pthread_mutex_destroy(&chan_mutex);
//     pthread_mutex_destroy(&cout_mutex);
    
    for(int i=0;i<chan;++i)
    {
        delete[] filterConfig[i].b;
        delete[] filterConfig[i].a;
    }
    delete[] filterConfig;
    return;
}