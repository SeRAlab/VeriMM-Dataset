module top_module(
  input clk,
  input signed [15 : 0] a,
  input signed [15 : 0] b,
  output reg signed [31 : 0] p
);always @(posedge clk) begin
    p <= a * b;
end

// negate the output if either input is negative
always @(*) begin
    if (a < 0 || b < 0) begin
        p <= -p;
    end
end

endmodule