module decrementer (
  input clk,
  input en,
  input rst,
  output reg [9:0] count);always @(posedge clk or posedge rst) begin
    if (rst)
        count <= 10'b1111111111;
    else if (en)
        count <= count - 1;
end
endmodule