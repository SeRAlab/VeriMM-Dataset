module counter(
    input clk,
    input rst,
    input en,

    output [3:0] count
);

reg [3:0] count;

always @(posedge clk or posedge rst)
begin
  if (rst)
    count <= 4'b0000;
  else if (en)
    count <= (count == 4'b1111) ? 4'b0000 : count + 1;
end

endmodule