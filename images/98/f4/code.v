module up_counter (
  input clk,
  input enable,
  input clear,
  output reg [9:0] count,
  output reg rollover
);

  always @(posedge clk) begin
    if (clear) begin
      count <= 10'b0000000000;
      rollover <= 1'b0;
    end
    else if (enable) begin
      if (count == 10'b1111111111) begin
        count <= 10'b0000000000;
        rollover <= 1'b1;
      end else begin
        count <= count + 1'b1;
        rollover <= 1'b0;
      end
    end
  end

endmodule