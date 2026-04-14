module lfsr (
  input clk,
  input ld,
  input [5:0] d,
  output reg [5:0] q);always @(posedge clk) begin
    if (ld)
        q <= d;
    else
        q <= {q[4:0], q[5] ^ q[4]};
end
endmodule