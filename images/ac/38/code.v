module reg16(
    input clk,
    input rst,
    input en,
    input [15:0] data_in,

    output reg [15:0] data_out
);

always @(posedge clk or posedge rst)
begin
  if (rst)
    data_out <= 16'b0000000000000000;
  else if (en)
    data_out <= data_in;
end

endmodule