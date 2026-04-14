module binary_counter(
  input clk,
  input reset,
  input enable,
  output reg [2:0] count
);

  always @(posedge clk) begin
    if (reset)
      count <= 0;
    else if (enable)
      count <= count + 1;
  end

endmodule