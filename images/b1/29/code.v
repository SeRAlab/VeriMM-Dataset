module top_module(
    input clk,
    input [1:0] A,
    input [1:0] B,
    output reg [3:0] P,
    output reg [3:0] Q
);reg [1:0] A_reg;
reg [1:0] B_reg;

always @ (posedge clk) begin
    A_reg <= A;
    B_reg <= B;
    P <= A_reg * B_reg[0];
    Q <= A_reg * B_reg[1];
end

endmodule