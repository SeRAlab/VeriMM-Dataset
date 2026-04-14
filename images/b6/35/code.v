module top_module(
  input clk, // input clock signal
  input rst, // synchronous reset signal
  output reg [15:0] count // output count value
);always @(posedge clk) begin
    if (rst) begin
      count <= 0;
    end else if (count == 65535) begin
      count <= 0;
    end else begin
      count <= count + 1;
    end
  end

endmodule