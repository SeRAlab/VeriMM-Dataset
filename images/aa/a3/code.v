module top_module(
  input clk,
  input reset,
  input [31:0] data_in,
  input [4:0] shift_amount,
  output [31:0] data_out
);reg [31:0] shifted_data;
  
  always @(posedge clk) begin
    if (reset) begin
      shifted_data <= 0;
    end else begin
      if (shift_amount > 0) begin
        shifted_data <= data_in << shift_amount;
      end else if (shift_amount < 0) begin
        shifted_data <= data_in >>> -shift_amount;
      end else begin
        shifted_data <= data_in;
      end
    end
  end
  
  assign data_out = shifted_data;
  
endmodule