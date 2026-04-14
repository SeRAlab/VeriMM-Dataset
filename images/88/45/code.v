module up_down_counter(
    input clk,
    input rst,
    input en,
    input dir,
    output reg [7:0] count
);

always @(posedge clk)
begin
  if (rst)
    count <= 0;
  else if (en)
  begin
    if (dir)
      count <= count + 1;
    else
      count <= count - 1;
  end
end

endmodule