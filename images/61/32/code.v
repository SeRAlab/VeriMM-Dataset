module top_module(
   input clk,
   input rst,
   input [31:0] data_in,
   input [31:0] shift_amt,
   output reg [31:0] data_out
);reg [31:0] shift_reg;

always @(posedge clk) begin
   if (rst) begin
      shift_reg <= 0;
   end else begin
      if (shift_amt > 0 && shift_amt < 32) begin
         shift_reg <= shift_reg << shift_amt; // Left shift
         shift_reg[0] <= data_in[0]; // Input the new data
      end else if (shift_amt > 0 && shift_amt >= 32) begin
         shift_reg <= 0; // Clear if shifting by 32 or more
      end else if (shift_amt < 0 && -shift_amt < 32) begin
         shift_reg <= shift_reg >> -shift_amt; // Right shift
         shift_reg[31] <= data_in[31]; // Input the new data
      end else if (shift_amt < 0 && -shift_amt >= 32) begin
         shift_reg <= 0; // Clear if shifting by 32 or more
      end else begin
         shift_reg <= data_in; // Load data
      end
   end
end

assign data_out = shift_reg;

endmodule