module top_module(
  input clk,
  input rstn,
  input [7:0] rdelay,
  output reg rst
);reg [7:0] count;

  always @(posedge clk or negedge rstn) begin
    if (~rstn) begin
      rst <= 1'b0;
      count <= 8'd0;
    end
    else begin
      if (count < rdelay) begin
        rst <= 1'b0;
        count <= count + 1;
      end
      else begin
        rst <= 1'b1;
      end
    end
  end

endmodule