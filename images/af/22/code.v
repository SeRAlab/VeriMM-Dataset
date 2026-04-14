module top_module(rst, clk, ctr, data_in, data_out);parameter N=32;
  
  input rst;
  input clk;
  input [1:0] ctr; 
  input [N-1:0] data_in;
  output reg [N-1:0] data_out;
  
  always @(posedge clk) begin
    if (rst) begin
      data_out <= 0;
    end else begin
      case (ctr)
        2'b00  : data_out <= data_in;
        2'b01  : data_out <= 0;
        default: data_out <= data_out;
      endcase 
    end
  end
endmodule