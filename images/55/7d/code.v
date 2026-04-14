module top_module(FuncCode, ALUOp, ALUCtl);input     [5:0]     FuncCode;
     input     [1:0]     ALUOp;
     
     output    [3:0]     ALUCtl;
     
     reg       [3:0]     ALUCtl;
     
     always @(*)
     begin
          
          casex({FuncCode, ALUOp})                      
               8'b100000_10   :    ALUCtl <= 4'b0010;   
               8'b100010_10   :    ALUCtl <= 4'b0110;   
               8'b100100_10   :    ALUCtl <= 4'b0000;   
               8'b100101_10   :    ALUCtl <= 4'b0001;   
               8'b101010_10   :    ALUCtl <= 4'b0111;   
               8'b100111_10   :    ALUCtl <= 4'b1100;   
                                             
                                                        
               8'bxxxxxx_00   :    ALUCtl <= 4'b0010;   
               8'bxxxxxx_x1   :    ALUCtl <= 4'b0110;   
               default        :    ALUCtl <= 4'bxxxx;   
          endcase
     end
endmodule