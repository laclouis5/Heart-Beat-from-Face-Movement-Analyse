function [ signal ] = creer_signal(duree, ips, f_card, amp_card, f_resp, amp_resp, amp_bruit)
    
    t = 0:1/ips:(duree - 1/ips);

    sig_card   = amp_card*sin(2*pi*f_card*t);
    bruit_resp = amp_resp*sin(2*pi*f_resp*t);
    bruit_hf   = amp_bruit*randn(length(sig_card), 1).';

    signal = sig_card + bruit_resp + bruit_hf;
    
end