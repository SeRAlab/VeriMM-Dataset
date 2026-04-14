module top_module(Func, AluOp, AluCtrl);input [5:0] Func;
  input [1:0] AluOp;
  output reg [2:0] AluCtrl;

  always @*
    casez({AluOp,Func}) 
      8'b00zzzzzz: AluCtrl <= 3'b010; 
      8'b01zzzzzz: AluCtrl <= 3'b110; 
      8'b10100000: AluCtrl <= 3'b010; 
      8'b10100010: AluCtrl <= 3'b110; 
      8'b10100100: AluCtrl <= 3'b000; 
      8'b10100101: AluCtrl <= 3'b001; 
      8'b10101010: AluCtrl <= 3'b111; 
	  default: AluCtrl <= 3'bxxx; 
    endcase
endmodule