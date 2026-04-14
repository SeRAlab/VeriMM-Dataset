module top_module(
    M4,
    ALU_out,
    Shift_out,
    MUX_4_out
    );parameter N=16;
input [N-1:0] ALU_out;
input [N-1:0] Shift_out;
input M4;
output reg [N-1:0] MUX_4_out;

always @ (*)
    
    begin 
    if (M4==0)
    MUX_4_out= ALU_out;
    
    else 
    MUX_4_out= Shift_out;
    end

endmodule