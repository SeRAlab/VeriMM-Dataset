module up_down_counter_16bit_async_clear (
  input clk,
  input clear,
  input enable,
  input direction,
  output reg [15:0] count
);

  always @(posedge clk or posedge clear) begin
    if (clear) begin
      count <= 16'b0000000000000000;
    end
    else if (enable) begin
      if (direction) begin
        count <= count + 1'b1;
      end else begin
        count <= count - 1'b1;
      end
    end
  end

endmodule