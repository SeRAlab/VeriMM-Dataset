module phase_shifter(  
    input [4:0] phase_in,  
    output [4:0] phase_out  
);  
    parameter SHIFT_AMOUNT = 3;  
    assign phase_out = (phase_in + SHIFT_AMOUNT) % 32;  
endmodule