module updown_counter(
    input clk,
    input rst,
    input up_down,

    output [3:0] count
);

reg [3:0] count;

always @(posedge clk)
begin
  if (rst)
    count <= 4'b0000;
  else if (up_down)
    count <= count + 1;
  else
    count <= count - 1;
end

endmodule