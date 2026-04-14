module up_down_counter(
    input clk,
    input rst,
    input ctrl,

    output [2:0] count
);

reg [2:0] count;

always @(posedge clk or posedge rst)
begin
  if (rst)
    count <= 3'b000;
  else if (ctrl)
    count <= (count == 3'b111) ? 3'b000 : count + 1;
  else
    count <= (count == 3'b000) ? 3'b111 : count - 1;
end

endmodule