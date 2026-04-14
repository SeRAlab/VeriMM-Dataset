module reg_16bit_enable(
    input clk,
    input en,
    input [15:0] d,
    input rst,
    output reg [15:0] q
);

always @(posedge clk or posedge rst)
begin
  if (rst)
    q <= 16'b0;
  else if (en)
    q <= d;
end

endmodule