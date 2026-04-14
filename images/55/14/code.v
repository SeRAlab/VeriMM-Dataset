module top_module(
  input clk,
  input rst,
  input enable,
  input load,
  input [2:0] data_in,
  output reg [2:0] count
);always @(posedge clk or negedge rst) begin
    if (!rst) begin
      count <= 3'b0;
    end else if (enable) begin
      if (load) begin
        count <= data_in;
      end else begin
        count <= count + 1;
      end
    end
  end

endmodule