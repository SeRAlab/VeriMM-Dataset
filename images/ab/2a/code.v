module alu_32bit (alu_out, clk, reset, en, data_a, data_b, alu_ctrl);
   input clk, reset, en;
   input [31:0] data_a, data_b;
   input [2:0] alu_ctrl;
   output [31:0] alu_out;
   
   reg [31:0] alu_out;
   
   always @(posedge clk or posedge reset) begin
      if (reset)
         alu_out <= 32'b0;
      else if (en) begin
         case (alu_ctrl)
            3'b000: alu_out <= data_a + data_b;  // Addition
            3'b001: alu_out <= data_a - data_b;  // Subtraction
            3'b010: alu_out <= data_a & data_b;  // Bitwise AND
            3'b011: alu_out <= data_a | data_b;  // Bitwise OR
            3'b100: alu_out <= data_a ^ data_b;  // Bitwise XOR
            default: alu_out <= 32'b0;
         endcase
      end
   end
   
endmodule