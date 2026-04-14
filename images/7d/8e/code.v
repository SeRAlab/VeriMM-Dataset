module top_module(
  input clk,
  input reset,
  input up_down,
  output reg [1:0] count
);always @(posedge clk or posedge reset) begin
  if (reset) begin
    count <= 2'b0;
  end else begin
    if (up_down) begin
      count <= count + 2'b1;
    end else begin
      count <= count - 2'b1;
    end
  end
end

endmodule