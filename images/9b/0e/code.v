module top_module(
    input clk,            // Added clk input
    input [3:0] in,
    output reg [7:0] out
);reg [3:0] in_reg;
reg [7:0] square_reg;

always @(posedge clk) begin
    in_reg <= in;
    square_reg <= {2'b0, in_reg[3:2] * in_reg[3:2], 2'b0, in_reg[1:0] * in_reg[1:0]}; // Changed ** to *
end

assign out = square_reg;

endmodule