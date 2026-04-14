module top_module(
  input clk,
  input reset,
  input enable,
  input load,
  input [31:0] data,
  output reg [31:0] q
);reg [31:0] count;

  always @(posedge clk) begin
    if (reset) begin
      count <= 0;
      q <= 0;
    end else if (enable) begin
      if (load) begin
        count <= data;
        q <= data;
      end else begin
        count <= count + 1;
        q <= count;
      end
    end
  end

endmodule