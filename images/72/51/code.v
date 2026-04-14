module top_module(
  input clk,
  input reset,
  input count_up,
  output reg [3:0] count
);always @(posedge clk or posedge reset) begin
    if (reset) begin
      count <= 4'b0000;
    end else if (count_up) begin
      if (count == 4'b1111) begin
        count <= 4'b0000;
      end else begin
        count <= count + 1;
      end
    end else begin
      if (count == 4'b0000) begin
        count <= 4'b1111;
      end else begin
        count <= count - 1;
      end
    end
  end

endmodule