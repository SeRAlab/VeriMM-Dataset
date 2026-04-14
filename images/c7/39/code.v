module counter_4bit (
  input clk,
  input reset,
  input enable,
  output reg [3:0] count
);

always @(posedge clk) begin
  if (reset) begin
    count <= 4'b0000;
  end else if (enable) begin
    count <= count + 4'b0001;
  end
end

endmodule
