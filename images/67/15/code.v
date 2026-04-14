module top_module(
  // inputs
  input clk,
  input [7:0] A,
  input [7:0] B,
  // outputs
  output reg [7:0] C,
  output reg overflow
);always @(posedge clk) begin
    // Calculate sum
    C <= A + B;
    
    // Check for overflow
    if (C > 255) begin
      C <= C[6:0]; // discard most significant bit
      overflow <= 1;
    end else begin
      overflow <= 0;
    end
  end

endmodule