module top_module(
    input [3:0] bcd_digit,  // Changed input width to accommodate a single BCD digit
    input mode,
    input clk,
    output reg [7:0] excess_3
);reg [3:0] excess_3_digit;

always @(posedge clk) begin
    excess_3_digit = bcd_digit + (mode ? 4'd5 : 4'd3); // Adjusted for BCD digit input range
    excess_3 <= {excess_3_digit, 4'b0000}; // Outputs excess-3 + 4 zero bits (standard for excess-3 code)
end

endmodule