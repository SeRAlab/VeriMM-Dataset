module top_module(
  input clk,
  input reset,
  input [31:0] data,
  input [4:0] shift_amt,
  output [31:0] shifted_data
);reg [31:0] shifted_data_reg;
  
  always @(posedge clk or posedge reset) begin
    if (reset) begin
      shifted_data_reg <= 0;
    end else begin
      if (shift_amt == 0) begin
        shifted_data_reg <= data;
      end else if (shift_amt[4] == 1) begin
        shifted_data_reg <= data << shift_amt[3:0];
      end else if (shift_amt[4] == 0) begin
        shifted_data_reg <= data >> shift_amt[3:0];
      end
    end
  end
  
  assign shifted_data = shifted_data_reg;
  
endmodule