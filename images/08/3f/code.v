module phase_shifter (  
    input [4:0] phase_in,  
    input [2:0] shift_amount,  
    output reg [4:0] phase_out  
);  
    always @(phase_in, shift_amount) begin  
        phase_out = (phase_in >> shift_amount) | (phase_in << (5 - shift_amount));  
    end  
endmodule