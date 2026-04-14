module top_module(
  input clk,
  input reset,
  input up,
  input down,
  output reg [2:0] count
);always @(posedge clk or posedge reset) begin
    if (reset) begin
      count <= 3'b0;
    end else if (up) begin
      if (count == 3'b111) begin
        count <= 3'b0;
      end else begin
        count <= count + 1;
      end
    end else if (down) begin
      if (count == 3'b000) begin
        count <= 3'b111;
      end else begin
        count <= count - 1;
      end
    end
  end

endmodule