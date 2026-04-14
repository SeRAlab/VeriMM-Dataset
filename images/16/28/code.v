module phase_shifter(  
    input [3:0] phase_in,  
    input [1:0] shift_amount,  
    output reg [3:0] phase_out  
);  
    always @(*) begin  
        phase_out = (phase_in + (shift_amount * 4)) % 16;  
    end  
endmodule