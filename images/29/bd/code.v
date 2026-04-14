module phase_shifter (  
    input [2:0] phase_offset,  
    input [2:0] input_signal,  
    output [2:0] output_signal  
);  
    assign output_signal = (input_signal + phase_offset) % 8;  
endmodule