module top_module(
  input [3:0] a, // 4-bit input a
  input [3:0] b, // 4-bit input b
  input [1:0] control, // 2-bit control input
  output reg out // Single bit output
);// Comparing a and b based on control input
  always @(*) begin
    case (control)
      2'b00: out = (a > b) ? 1 : 0; // Greater than comparison
      2'b01: out = (a < b) ? 1 : 0; // Less than comparison
      2'b10: out = (a == b) ? 1 : 0; // Equal to comparison
      2'b11: out = (a != b) ? 1 : 0; // Not equal to comparison
      default: out = 0; // Default output
    endcase
  end
  
endmodule