module top_module(
  input clk,
  input rst,
  input [31:0] in_data,
  input in_valid,
  output reg [31:0] out_data,
  output reg out_valid
);always @(posedge clk, negedge rst) begin
    if (!rst) begin
      out_data <= 32'h0;
      out_valid <= 1'b0;
    end
    else if (in_valid) begin
      out_data <= in_data;
      out_valid <= 1'b1;
    end
    else begin
      out_valid <= 1'b0;
    end
  end

endmodule