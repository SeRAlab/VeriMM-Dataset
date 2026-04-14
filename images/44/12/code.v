module top_module(
    input clk,          // Clock input
    input rst,          // Synchronous active-high reset
    input [7:0] in,     // 8-bit input
    output reg [7:0] out // 8-bit output with reverse bit ordering
);reg [7:0] in_reg;       // Register to hold input data

always @(posedge clk) begin
    if (rst) begin
        in_reg <= 8'b0; // Reset input register to 0
        out <= 8'b0;    // Reset output to 0
    end
    else begin
        in_reg <= in;   // Store input data in register
        out <= {in_reg[7], in_reg[6], in_reg[5], in_reg[4], in_reg[3], in_reg[2], in_reg[1], in_reg[0]}; // Reverse the order of the bits
    end
end

endmodule