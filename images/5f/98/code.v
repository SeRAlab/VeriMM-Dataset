module top_module(
  input clk,
  input reset,
  output reg [2:0] count
);always @(posedge clk or negedge reset) begin
    if (reset == 0) begin
      count <= 0;
    end else begin
      if (count == 7) begin
        count <= 0;
      end else begin
        count <= count + 1;
      end
    end
  end

endmodule