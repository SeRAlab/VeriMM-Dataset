module phase_shifter(  
    input [4:0] in_signal,  
    output [4:0] out_signal  
);  
    assign out_signal = {in_signal[3:0], in_signal[4]};  
endmodule