module top_module(
  input wire clk,
  input wire reset,
  input wire load,
  input wire [3:0] data_in,
  output reg [3:0] data_out
);always @(posedge clk or posedge reset) begin
    if (reset) begin
      data_out <= 0;
    end else if (load) begin
      data_out <= data_in;
    end
  end

endmodule