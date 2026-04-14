module counter_3bit (
  input clk,
  input reset,
  input enable,
  output reg [2:0] count
);

always @(posedge clk) begin
  if (reset) begin
    count <= 0;
  end else if (enable) begin
    if (count == 7) begin
      count <= 0;
    end else begin
      count <= count + 1;
    end
  end
end

endmodule
