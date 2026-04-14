module shift_register (
  input clk,
  input sh_en,
  input rst,
  input [7:0] din,
  output reg [7:0] dout);

always @(posedge clk) begin
    if (rst)
        dout <= 8'b00000000;
    else if (sh_en)
        dout <= {dout[6:0], din[0]};
end
endmodule