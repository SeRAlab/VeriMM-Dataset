module top_module(output reg flag, input din, clk, rst_n);reg [2:0] buffer;
always @(negedge clk)
begin
  if(rst_n==1'b0)
  begin
    buffer = 3'bx;
    flag = 1'b0;
  end
  else
  begin
    if({buffer, din}==4'b1101 || {buffer, din}==4'b0110)
      flag = 1'b1;
    else
      flag = 1'b0;
    buffer = {buffer[1:0], din};
  end
end
endmodule