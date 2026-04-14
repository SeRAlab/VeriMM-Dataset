module top_module(input A, B, output reg q_nand, q_nor, q_xnor, q_not);always @(A, B) begin
      q_nand = A ~& B;
      q_nor  = A ~| B;
      q_xnor = A ~^ B;
      q_not  = ~A;
   end

endmodule