module top_module(input [1:0] aluop, 
                  input [5:0] funct, 
                  output reg [2:0] alucontrol 
                  );parameter ADD = 6'b100000;
   parameter SUB = 6'b100010;
   parameter AND = 6'b100100;
   parameter OR  = 6'b100101;
   parameter SLT = 6'b101010;
   
   
   
   always @(*)
     case (aluop) 
       2'b00: alucontrol = 3'b010; 
       2'b01: alucontrol = 3'b110; 
       2'b10: case (funct) 
                ADD: alucontrol = 3'b010; 
                SUB: alucontrol = 3'b110; 
                AND: alucontrol = 3'b000; 
                OR:  alucontrol = 3'b001; 
                SLT: alucontrol = 3'b111; 
                
              endcase 
       
     endcase 
endmodule