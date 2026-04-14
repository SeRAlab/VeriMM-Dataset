module top_module(src0, src1, ctrl, shamt, result, ov, zr, ne);input [15:0] src0, src1;
  input [2:0] ctrl;
  input [3:0] shamt;
  
  output [15:0] result;
  output ov, zr, ne;

  wire [15:0] unsat, subOp;

  localparam add = 3'b000; 
  localparam lhb = 3'b001;
  localparam sub = 3'b010;
  localparam andy = 3'b011;
  localparam nory = 3'b100;
  localparam sll = 3'b101;
  localparam srl = 3'b110;
  localparam sra = 3'b111;

  assign unsat = (ctrl==add) ? src0+src1:
                 (ctrl==lhb) ? {src0[7:0], src1[7:0]}:
                 (ctrl==sub) ? src0-src1:
                 (ctrl==andy)? src0&src1:
                 (ctrl==nory)? ~(src0|src1):
                 (ctrl==sll) ? src0<<shamt:
                 (ctrl==srl) ? src0>>shamt:
                 (ctrl==sra) ? {$signed(src0) >>> shamt}:
                 17'h00000; 

  
  
  assign subOp = ~src1 + 1'b1;
  assign src1Sign = ctrl==sub ? ((src1==16'h8000) ? 1'b0 : subOp[15]) : src1[15];          

  
  
  assign subCornerCase = !(ctrl==sub && src1 == 16'h8000 && src0[15]); 
  assign negativeOverflow = (src0[15] && src1Sign && !unsat[15] && subCornerCase);
  
  
  assign positiveOverflow = (!src0[15] && !src1Sign && unsat[15]);

  
  assign result = (positiveOverflow && (ctrl==add || ctrl==sub)) ? 16'h7fff :
               (negativeOverflow && (ctrl==add || ctrl==sub)) ? 16'h8000 : unsat;

  
  assign ov = (positiveOverflow || negativeOverflow);

  assign zr = ~|result;

  
  assign ne = result[15];
  
endmodule