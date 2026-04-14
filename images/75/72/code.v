module top_module(
    input clk,           // Added clk input
    input [3:0] A,
    input [3:0] B,
    output reg [7:0] Q
);reg [3:0] A_reg, B_reg;
reg [7:0] Q_reg;

always @(posedge clk) begin
    A_reg <= A;
    B_reg <= B;
end

always @(posedge clk) begin
    Q_reg <= A_reg * B_reg;
end

assign Q = Q_reg;

endmodule