module counter(
  input clk,
  input reset,
  input [3:0] init_value,
  output reg [3:0] count
);

  always @(posedge clk) begin
    if (reset) begin
      count <= init_value;
    end else begin
      count <= count + 1;
    end
  end

endmodule