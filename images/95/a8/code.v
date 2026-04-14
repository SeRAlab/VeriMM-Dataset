module top_module(
    input [3:0] A,
    input [3:0] B,
    input clk,          // Added clk as an input
    output [3:0] C,
    output D
);reg [3:0] C_reg;
reg D_reg;

always @(posedge clk) begin
    C_reg <= A & B;    // Perform bitwise AND directly in the always block
    D_reg <= C_reg[3];
end

assign C = C_reg;
assign D = D_reg;

endmodule