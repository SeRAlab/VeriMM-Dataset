module binary_counter_sync_preset (
  input clk,
  input preset,
  input enable,
  output reg [3:0] count
);

  always @(posedge clk) begin
    if (preset) begin
      count <= 4'b0101;
    end
    else if (enable) begin
      count <= count + 1'b1;
    end
  end

endmodule