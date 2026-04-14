module top_module(CLK, RST, R, S, Q);input       CLK, RST;
   input           R, S;   
   output  reg        Q;  
   
   always@(posedge CLK, posedge RST)
      if(RST) Q <= 1'b0;
      else
         case({S,R})
            2'b00: Q <= Q;
            2'b01: Q <= 1'b0;
            2'b10: Q <= 1'b1;
            2'b11: Q <= Q;
         endcase

endmodule