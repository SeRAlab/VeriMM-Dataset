module top_module(
    input [2:0] A,
    input [2:0] B,
    input C_In,
    output reg [2:0] Out,
    output reg C_Out
    );always @(*) begin
    {C_Out, Out} = A + B + C_In;
end


endmodule