module up_down_counter(
    input clk,
    input rst,
    input enable,
    input mode,
    output reg [7:0] count
);

always@(posedge clk)
begin
  if(rst)
    count <= 0;
  else if(enable)
  begin
    if(mode)
      count <= count + 1;
    else
      count <= count - 1;
  end
end

endmodule