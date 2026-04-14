module up_down_counter_8bit_sync_clear (
  input clk,
  input clear,
  input enable,
  input direction,
  output reg [7:0] count
);

  always @(posedge clk) begin
    if (clear) begin
      count <= 8'b00000000;
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