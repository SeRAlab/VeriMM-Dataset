module shift_register (
  input clk,
  input reset,
  input load,
  input [15:0] parallel_in,
  output reg [15:0] q);always @(posedge clk) begin
    if (reset) q <= 16'b0000000000000000;
    else if (load) q <= parallel_in;
    else q <= {1'b0, q[15:1]};
end

endmodule