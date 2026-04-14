module top_module(
    input clk,          // Clock input
    input rst,          // Synchronous active-high reset
    input [7:0] in,     // 8-bit input
    output reg [7:0] out // 8-bit output with reverse bit ordering
);reg [7:0] shift_reg;    // Shift register to store input bits

always @(posedge clk) begin
    if (rst) begin
        shift_reg <= 8'b0;   // Reset shift register to 0
        out <= 8'b0;         // Reset output to 0
    end else begin
        shift_reg <= {shift_reg[6:0], in[0]}; // Shift input bit into shift register
        out <= {out[6:0], shift_reg[0]};      // Output bit from shift register
    end
end

endmodule