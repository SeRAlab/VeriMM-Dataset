module counter_3bit_up_down 
(
  input clk,
  input rst,
  input up,
  input down,
  output reg [2:0] count
);

  always @(posedge clk or posedge rst) begin
    if (rst)
      count <= 3'b000;
    else if (up && !down)
      count <= count + 1;
    else if (!up && down)
      count <= count - 1;
  end

endmodule