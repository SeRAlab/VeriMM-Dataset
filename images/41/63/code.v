module register_12bit (
  input clk,
  input ld,
  input rst,
  input [11:0] d,
  output reg [11:0] q);always @(posedge clk) begin
    if (rst)
        q <= 12'b0;
    else if (ld)
        q <= d;
end
endmodule