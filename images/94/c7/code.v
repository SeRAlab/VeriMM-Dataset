module register (
  input clk,
  input en,
  input rst,
  input [15:0] din,
  output reg [15:0] data);

always @(posedge clk) begin
    if (rst)
        data <= 16'b0000000000000000;
    else if (en)
        data <= din;
end
endmodule