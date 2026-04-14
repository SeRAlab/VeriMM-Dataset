module top_module(
  input clk,
  input reset,
  input enable,
  input direction,
  output reg [3:0] count
);always @(posedge clk) begin
  if (reset) begin
    count <= 0;
  end else begin
    if (enable) begin
      if (direction) begin
        if (count == 15) begin
          count <= 0;
        end else begin
          count <= count + 1;
        end
      end else begin
        if (count == 0) begin
          count <= 15;
        end else begin
          count <= count - 1;
        end
      end
    end
  end
end

endmodule