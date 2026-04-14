module counter (
  input clk,
  input reset,
  input enable,
  output reg [3:0] count
);

  always @(posedge clk) begin
    if (reset == 0) begin
      count <= 0;
    end else if (enable) begin
      count <= count + 1;
    end
  end

endmodule