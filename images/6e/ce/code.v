module binary_counter_16bit_sync_clear (
  input clk,
  input clear,
  input enable,
  output reg [15:0] count
);

  always @(posedge clk) begin
    if (clear) begin
      count <= 16'b0000000000000000;
    end
    else if (enable) begin
      count <= count + 1'b1;
    end
  end

endmodule