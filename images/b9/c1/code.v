module top_module(
    input [31:0] B_In,
    input [31:0] C,                    
    input MUL_HiLo, LD_MUL, U,
    output [31:0] B_Out                    
);reg [63:0] op1, op2;
    reg [63:0] MUL;


    always @(*) begin
        op1 = (({{32{B_In[31]}}, {B_In}} & {64{U}}) | ({{32{1'b0}}, {B_In}} & {64{!U}})); 
        op2 = (({{32{C[31]}}, {C}} & {64{U}}) | ({{32{1'b0}}, {C}} & {64{!U}})); 
        MUL = (LD_MUL)? op1 * op2 : MUL;
    end

    assign B_Out = (({32{MUL_HiLo}} & MUL[63:32]) | ({32{!MUL_HiLo}} & MUL[31:0]));
endmodule