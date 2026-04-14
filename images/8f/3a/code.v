module gray_counter(
  input clk,
  input rst_n,
  output reg [1:0] count
);

  always @(posedge clk or negedge rst_n) begin
    if (~rst_n)
      count <= 2'b00;
    else
      case (count)
        2'b00: count <= 2'b01;
        2'b01: count <= 2'b11;
        2'b11: count <= 2'b10;
        2'b10: count <= 2'b00;
      endcase
  end

endmodule