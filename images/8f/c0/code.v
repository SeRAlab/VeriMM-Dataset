module gray_counter (
  input clk,
  input reset,
  input enable,
  output reg [1:0] count
);

  always @(posedge clk) begin
    if (reset)
      count <= 2'b00;
    else if (enable) begin
      case (count)
        2'b00: count <= 2'b01;
        2'b01: count <= 2'b11;
        2'b11: count <= 2'b10;
        2'b10: count <= 2'b00;
        default: count <= 2'b00;
      endcase
    end
  end

endmodule