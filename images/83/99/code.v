module top_module(
   input signed [15:0] DATA_A, DATA_B,
   input [3:0] 	       S_ALU,
   output [15:0]       ALU_OUT,
   output [3:0]        FLAG_OUT);localparam IADD = 4'b0000;
   localparam ISUB = 4'b0001;
   localparam IAND = 4'b0010;
   localparam IOR = 4'b0011;
   localparam IXOR = 4'b0100;
   localparam ISLL = 4'b1000;
   localparam ISLR = 4'b1001;
   localparam ISRL = 4'b1010;
   localparam ISRA = 4'b1011;
   localparam IIDT = 4'b1100;
   localparam INON = 4'b1111;

   wire S, Z, V;

   function [16:0] amux(
      input signed [15:0] A, B,
      input [3:0] Selector);

      case (Selector)
         IADD : amux = {1'b0, A} + {1'b0, B};
         ISUB : amux = {1'b0, A} - {1'b0, B};
         IAND : amux = {1'b0, A & B};
         IOR  : amux = {1'b0, A | B};
         IXOR : amux = {1'b0, A ^ B};
         ISLL : amux = {1'b0, A} << B[3:0];
         ISLR : amux = ({1'b0, A} << B[3:0]) | (A >> 16 - B[3:0]);
         ISRL : amux = {B[3:0] > 0 ? A[B[3:0] - 1] : 1'b0, A >> B[3:0]};
         ISRA : amux = {B[3:0] > 0 ? A[B[3:0] - 1] : 1'b0, A >>> B[3:0]};
         IIDT : amux = {1'b0, B};
         INON : amux = 17'b0;
         default : amux = 17'b0;
      endcase
   endfunction
  
   wire [16:0] result;

   assign result = amux(DATA_A, DATA_B, S_ALU);
   assign ALU_OUT = result[15:0];
   assign S = result[15] == 1'b1 ? 1'b1 : 1'b0;
   assign Z = result[15:0] == 16'b0 ? 1'b1 : 1'b0;
   assign V = (((S_ALU == IADD) && (DATA_A[15] == DATA_B[15]) && (DATA_A[15] != result[15]))
               || ((S_ALU == ISUB) && (DATA_A[15] != DATA_B[15]) && (DATA_A[15] != result[15]))) ? 1'b1 : 1'b0;
   assign FLAG_OUT = {S, Z, result[16], V};
endmodule