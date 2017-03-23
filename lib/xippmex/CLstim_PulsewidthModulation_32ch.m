% This example will modulate the pulsewidth of a delivered stimulation 
% pulse on electrode 1 of the first Micro+Stim connected based on input 
% from a sensor connected to analog input channel 1. In this example a 
% force sensitive resistor is used where increasing force increases the 
% voltage input on analog input channel 1. When the force level is below 
% threshold, no stimulation will occur.  When the force level is above the 
% threshold, the stimulation pulses will be delivered at a constant 
% frequency with the pulsewidth of the biphasic pulse modulated based on 
% the level of the input.
%

%% Clean the world
close all; fclose('all'); clc; clear all; 


%% %%%%%%%%%%%%% Soft Parameter Initialization - May change as needed %%%%%%%%%%%%%%
anlgChan_idx  = 1;      % analog I/O FE channel to monitor for force
stimChan_idx  = 1:32;   % stim FE channel
stimFreq      = 50;     % stimulation Frequency (Hz)
pulseAmpSteps = 20;     % Sets the amplitude of stim (e.g. 20*7.5uA = 150uA)
pwAtThresh    = 50;     % stim PW when threshold crossed (us)
pwMax         = 500;    % max stim PW (us)
fs_us         = 200;    % duration of stim fast settle of recording (us)
window_ms     = 20;     % Length of window to analyze incoming analog data in control loop

%% %%%%%%%%%%%%%%%% Fixed Parameter Initialization - DO NOT CHANGE %%%%%%%%%%%%%%%%%
nipClock_us    = 1e6/3e4;           % 33.333 us
nipClock_ms    = nipClock_us * 1e3; % 0.0333 ms
msec2nip_clk   = 30;
nip_clk2sec    = 1/3e4;
nip_clk2msec   = nip_clk2sec * 1e3;
nip_clk2usec   = nip_clk2sec * 1e6;
AMP_NEURAL     = 0;              % used to set the input channel amp to measure neural voltages
AMP_STIM       = 1;              % used to set the input channel amp to measure stim voltage
stimAmp2V      = 0.50863e-3;
stimAmp2uV     = stimAmp2V * 1e6;

% Specific parameters used for this example
ipi_us         = 33;  % time between cathodic and anodic phases of stim (us)
forceThresh_mV = 150;
forceMax_mV    = 4500;
forceRange_mV  = forceMax_mV - forceThresh_mV;

%% %%%%%%%%%%%%%%%%%% NIP Hardware Initialization %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Initialize xippmex
status = xippmex;
if status ~= 1; error('Xippmex Did Not Initialize');  end

% Find all Micro+Stim and Analog channels
anlgChans = xippmex('elec','analog');
stimChans = xippmex('elec','stim');

% NOTE: This demo expects there to be one analog i/o and one micro+stim 
% front end attached to the NIP. So let's check if this is indeed the case.
if isempty(anlgChans); error('No analog hardware detected'); end

%make sure there is at least one micro+stim front end present
if isempty(stimChans); error('No stimulation hardware detected');  end

% Turn on 1 kS/s data stream, turn off 30 kS/s data stream to reduce load
xippmex('signal', anlgChans, '1ksps', ones(1,length(anlgChans)))
xippmex('signal', anlgChans, '30ksps', zeros(1,length(anlgChans)))

% Give the NIP some time to process any commands we have sent
pause(0.5)

%% %%%%%%%%%%%%% Stim Initialization %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Enable stimulation on the NIP.
% NOTE: If stimulation is not enabled, xippmex will enable and disable 
% stimulation for each stim sequence it receives. This will have the 
% undesirable side effect of killing queued stimulation sequences. Always 
% enable stimulation on the NIP before queueing multiple stimulation
% sequences.
xippmex('stim', 'enable', 0); pause(0.5)
xippmex('stim', 'enable', 1); pause(0.5)

% NOTE: This size is fixed and cannot be exceeded. Overflowing the buffer
% will cause the NIP to shut down all stimulation.
stimQueueSize = 8;

for i = 1:32
    cmd(i).elec    = stimChans(stimChan_idx(i));
    cmd(i).period  = floor(1/nip_clk2sec / stimFreq);
    cmd(i).repeats = 200;
    cmd(i).action  = 'curcyc';  % Valid 'action' options are: ['immed', 'curcyc', 'allcyc', 'at-time']
    
    cmdClear(i).elec = stimChans(stimChan_idx(i));
    cmdClear(i).period  = 20;
    cmdClear(i).repeats = 1;
    cmdClear(i).action  = 'immed';

    cmdClear(i).seq(1) = struct('length', 3, 'ampl', 0, 'pol', 0, ...
        'fs', 0, 'enable', 0, 'delay', 0, 'ampSelect', AMP_NEURAL);

end      

%% %%%%%%%%%%%%%%%% Set control parameters for stimulation %%%%%%%%%%%
pwRng        = pwMax - pwAtThresh; % range of stimulation PW
window_clk   = window_ms * msec2nip_clk;
ipi_cycls    = ipi_us / nipClock_us;
fs_cycls     = floor(fs_us / nipClock_us);
lastNipTime  = 0;
nipOffTime   = 0;
stimOff      = 0;

% Frequency of control loop. In this example, this cannot be faster than
% stimulation frequency. This is to prevent buffer commands to 
% stack up for each electrode (>8), which would cause buffer overrun
% and shut down stimulation for that electrode.
loopPrd_s = 1/stimFreq;

%% %%%%%%%%%%%%%% Run Control Loop %%%%%%%%%%%%%%%%%%%%%%%%
loopTimer = tic; loopTimeCur = toc(loopTimer);
while true
    
    % wait until loop period has occured
    nextTime = loopTimeCur + loopPrd_s;
    while toc(loopTimer) < nextTime; end
    loopTimeCur = toc(loopTimer);
    
    % Get the current NIP time
    curNipTime = xippmex('time');
    
    % chek if the NIP is still on-line
    if curNipTime == lastNipTime
        if nipOffTime == 0
            tic;
        end
        nipOffTime = toc;
        % if the nip has been offline for a second abort the program
        if nipOffTime > 1
            xippmex('close');
            error('NIP appears to be off-line. Exiting program... Bye!')
        end
    % if the NIP is on-line clear the off timer
    else
        nipOffTime = 0;
    end
    % update NIP time for the next pass through the loop    
    lastNipTime = curNipTime;
    
    % collect recent analog data
    winStart_clk = curNipTime - window_clk;
    [anlgData, actTime] = xippmex('cont', anlgChans(anlgChan_idx), window_ms, '1ksps', winStart_clk);

    % if the force threshold has been crossed, modulate the pw of
    % stimulation.  if the force is below threshold, shut off stimulation
    meanAnlg = mean(anlgData);
    if meanAnlg < forceThresh_mV
        if ~stimOff
            xippmex('stimseq', cmdClear);
            stimOff = 1;
        end
        continue
    else
        
        stimOff    = 0;
        forceDiff  = meanAnlg - forceThresh_mV;
        frqRngFrac = min(forceDiff/forceRange_mV, 1);
        
        % compute the stimulation parameters
        pw_us     = pwAtThresh + pwRng * frqRngFrac;
        pw_us     = min(pw_us, pwMax);
        pw_cycls  = pw_us / nipClock_us;
                
        % Lay out the stimulation pulse as a sequence of stim commands
        seq_idx = 1;

        % -------------------- cathodic phase -------------------- 
        cath_maj = floor(pw_cycls);
        cath_rem = pw_cycls - cath_maj;
        % NOTE: start with remainder portion (if it exists) of pulse to make 
        % latter phases easier to lay out
        if cath_rem > 0
            for i = 1:32
                cmd(i).seq(seq_idx) = struct('length', 1, 'ampl', ...
                    pulseAmpSteps, 'pol', 0, 'fs', 0, 'enable', 1, ...
                    'delay', floor(31*cath_rem), 'ampSelect', AMP_STIM);
            end
            seq_idx = seq_idx + 1;
        end

        if cath_maj > 0
            for i = 1:32
                cmd(i).seq(seq_idx) = struct('length', cath_maj, 'ampl', ...
                    pulseAmpSteps, 'pol', 0, 'fs', 0, 'enable', 1, ...
                    'delay', 0, 'ampSelect', AMP_STIM);
            end
            seq_idx = seq_idx + 1;
        end


        % -------------------- inter-phase interval --------------------
        ipi_maj = floor(ipi_cycls);
        ipi_rem = ipi_cycls - ipi_maj;
        if ipi_maj > 0
            for i = 1:32
                cmd(i).seq(seq_idx) = struct('length', ipi_maj, 'ampl', ...
                    0, 'pol', 0, 'fs', 0, 'enable', 0, 'delay', 0, ...
                    'ampSelect', AMP_STIM);
            end
            seq_idx = seq_idx + 1;
        end

        if ipi_rem > 0
            % NOTE: this cmd codes the transition to the anodic phase
            for i = 1:32
                cmd(i).seq(seq_idx) = struct('length', 1, 'ampl', ...
                    pulseAmpSteps, 'pol', 0, 'fs', 0, 'enable', 1, ...
                    'delay', floor(31*ipi_rem), 'ampSelect', AMP_STIM);
            end
            seq_idx = seq_idx + 1;
        end


        % -------------------- anodic phase -------------------- 
        anod_done = 0;
        if ipi_rem > 0
            anod_done = 1-ipi_rem;
        end
        anod_maj = floor(pw_cycls-anod_done);
        anod_rem = pw_cycls - anod_maj;
        % do the steady state cycles first
        if anod_maj > 0
            for i = 1:32
                cmd(i).seq(seq_idx) = struct('length', anod_maj, 'ampl', ... 
                    pulseAmpSteps, 'pol', 1, 'fs', 0, 'enable', 1, ...
                    'delay', 0, 'ampSelect', AMP_STIM);
            end
        end
        seq_idx = seq_idx + 1;
        % handle the remainder if it exists
        if anod_rem > 0
            for i = 1:32
                cmd(i).seq(seq_idx) = struct('length', 1, 'ampl', ...
                    pulseAmpSteps, 'pol', 1, 'fs', 0, 'enable', 1, ...
                    'delay', floor(31*anod_rem), 'ampSelect', AMP_STIM);
            end
            seq_idx = seq_idx + 1;
        end

        % -------------------- if fast settle --------------------
        if fs_cycls > 0
            for i = 1:32
                cmd(i).seq(seq_idx) = struct('length', fs_cycls, ...
                    'ampl', 0, 'pol', 1, 'fs', 1, 'enable', 1, ...
                    'delay', 0, 'ampSelect', AMP_STIM);
            end
        end

        % Execute stimulation
        xippmex('stimseq', cmd);
           
        
    end    
end

% let the user know the script is done
disp('Exiting Ripple Stim Demo .... Bye!')
xippmex('close');
         
         
         
         