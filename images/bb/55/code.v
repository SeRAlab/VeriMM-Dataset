module binary_counter_sync_clear (
  input clk,
  input clear,
  input enable,
  output reg [3:0] count
);

  always @(posedge clk) begin
    if (clear) begin
      count <= 4'b0000;
    end
    else if (enable) begin
      count <= count + 1'b1;
    end
  end

endmodule