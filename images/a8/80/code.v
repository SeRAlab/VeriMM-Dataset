module top_module(
  input clk,
  input rst,
  input [7:0] data_in,
  output reg [7:0] data_out
);reg parity;
  
  always @(posedge clk) begin
    if (rst) begin
      data_out <= 0;
      parity <= 0;
    end else begin
      data_out <= {data_in, parity};
      parity <= ^data_in;
    end
  end
  
endmodule