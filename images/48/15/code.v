module binary_counter_4bit_up_down(
  input clk,
  input rst_n,
  input up_down,
  output reg [3:0] count
);

  always @(posedge clk or negedge rst_n) begin
    if (~rst_n)
      count <= 4'b0000;
    else if (up_down)
      count <= (count == 4'b1111) ? 4'b0000 : count + 1;
    else
      count <= (count == 4'b0000) ? 4'b1111 : count - 1;
  end

endmodule