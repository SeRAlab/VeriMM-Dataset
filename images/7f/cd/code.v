module counter (
  input clk,
  input reset,
  input enable,
  input direction,
  output reg [3:0] count
);

  always @(posedge clk or posedge reset) begin
    if (reset) begin
      count <= 4'b0000;
    end
    else if (enable) begin
      if (direction) begin
        count <= count + 1'b1;
      end else begin
        count <= count - 1'b1;
      end
    end
  end

endmodule