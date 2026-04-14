module top_module(
  input [n-1:0] d,
  input [n-1:0] J,
  input [n-1:0] K,
  input [n-1:0] t,
  input [n-1:0] s,
  input [n-1:0] r,
  input clk,
  output reg [m-1:0] q_D,
  output reg [m-1:0] q_JK,
  output reg [m-1:0] q_T,
  output reg [m-1:0] q_SR
);parameter n = 1; // number of bits
parameter m = 1; // number of bits in output signals

always @(posedge clk) begin
  q_D <= d;
end

always @(posedge clk) begin
  if (J & ~K) begin
    q_JK <= ~q_JK;
  end else if (~J & K) begin
    q_JK <= q_JK;
  end
end

always @(posedge clk) begin
  if (t) begin
    q_T <= ~q_T;
  end else begin
    q_T <= q_T;
  end
end

always @(posedge clk) begin
  if (s) begin
    q_SR <= 1'b1;
  end else if (r) begin
    q_SR <= 1'b0;
  end else begin
    q_SR <= q_SR;
  end
end

endmodule