module updown_counter(
  input clk,
  input rst,
  input updown,
  output reg [7:0] count
);

  always @(posedge clk or posedge rst) begin
    if (rst)
      count <= 8'd0;
    else if (updown)
      count <= count + 8'd1;
    else
      count <= count - 8'd1;
  end

endmodule