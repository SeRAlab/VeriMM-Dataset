module up_down_counter(
    input clk,
    input rst,
    input mode,

    output reg [2:0] count
);

always @(posedge clk)
begin
  if (rst)
    count <= 3'b000;
  else if (mode)
    count <= count + 1;
  else
    count <= count - 1;
end

endmodule