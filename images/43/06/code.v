module up_down_counter_sync_clear (
  input clk,
  input clear,
  input enable,
  input direction,
  output reg [3:0] count
);

  always @(posedge clk) begin
    if (clear) begin
      count <= 4'b0000;
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