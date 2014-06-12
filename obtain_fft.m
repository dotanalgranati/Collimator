function [freq,amp,phase]=obtain_fft(x,w1,w2,ts,varargin)
%
%gives frequency and amplitude content of the signal in vector x
%
% Usage : [freq,amplitude,phase]=obtain_fft(x,w1,w2,ts,p,'units','signal')
%
% x : signal whose fft is sought
% [w1,w2] : is frequency range of interest
% ts : sampling period in seconds
% freq : frequency in rad/sec
% amp : amplitude
% phase : phase in degrees
% p : if equal to 1 also draws amplitude plot (closes all open plots)
% if equal to 2 draws phase plot also
% 'units' : units of the elements of vector x (lbf, N, rad/sec, etc)
% 'signal' : indicates the physical quantity (tension, velocity, etc)
% p, 'units', 'signal' are optional and may be omitted

N=length(x);
dd_fft=abs(fft(x));
phase=angle(fft(x));
dd_fft=dd_fft/N*2;
NN=floor([(w1*N*ts+1):(w2*N*ts+1)]);
freq=(NN-1)/N/ts;
amp=dd_fft(NN);
phase=phase(NN)*180/pi/2;
%[w1,a1,w2,a2]=pick12natfreq(freq,amp)
if nargin==5 | nargin==6 | nargin==7% only p is specified
    p=cell2mat(varargin(1));
    if p==1 | p==2
        if nargin==6 | nargin==7
            units=char(varargin(2));
            yunits=sprintf('Amplitude (%s)',units);
        else
            yunits='Amplitude';
        end
% close all
% figure(1)
        if p==2
            subplot(2,1,1)
        end
        if nargin==7
            titlestr=sprintf('of %s',char(varargin(3)));
        else
            titlestr='';
        end
        titlestr=sprintf('Frequency Content %s',titlestr);
        plot(freq,amp,'r-')
        ylabel(yunits)
        xlabel('\omega (Hz)')
        grid on
        title(titlestr)
        if p==2
            subplot(2,1,2)
            plot(freq,phase,'r-')
            ylabel('Phase (degrees)')
            xlabel('\omega (Hz)')
            grid on
        end
    end
end
return
