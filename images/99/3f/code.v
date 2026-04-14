module accumulator (
  input clk,
  input en,
  input rst,
  input [7:0] d,
  output reg [7:0] acc);always @(posedge clk or posedge rst) begin
    if (rst)
        acc <= 8'b0;
    else if (en)
        acc <= acc + d;
end
endmodule