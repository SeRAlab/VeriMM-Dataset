module binary_counter_async_preset (
  input clk,
  input preset,
  input enable,
  output reg [3:0] count
);

  always @(posedge clk or posedge preset) begin
    if (preset) begin
      count <= 4'b1000;
    end
    else if (enable) begin
      count <= count + 1'b1;
    end
  end

endmodule