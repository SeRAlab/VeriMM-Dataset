module parallel_load_register (
  input clk,
  input ld,
  input clr,
  input [3:0] d,
  output reg [3:0] q);always @(posedge clk) begin
    if (clr)
        q <= 4'b0;
    else if (ld)
        q <= d;
end
endmodule