module top_module(
  input clk, 
  input rst, 
  output reg [7:0] out
);always @(posedge clk) begin
    if (rst) begin
      out <= 8'b0;
    end else if (out == 8'hFF) begin
      out <= 8'b0;
    end else begin
      out <= out + 1;
    end
  end

endmodule