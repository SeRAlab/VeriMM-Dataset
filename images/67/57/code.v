module top_module(input [1:0] op,input [5:0] funct,input [3:0]rd,
                    output reg [1:0] flagw,output wire pcs,output wire regw,
                    output wire memw,output wire memtoreg,output wire alusrc,
                    output wire [1:0] immsrc,output wire [1:0] regsrc,output reg[1:0] alucontrol ,output wire nowrite
                    );reg [9:0] control;
  wire aluop;
  wire branch;
  always @*
  case(op)
    2'b00: if(funct[5]) control=10'b0001001001;   
           else         control=10'b0000001001;   
    2'b01: if(funct[0]) control=10'b0101011000;   
           else         control=10'b0011010100;   
    2'b10:              control=10'b1001100010;   
	 default:control=10'bxxxxxxxxxx;
   endcase
  assign {branch,memtoreg,memw,alusrc,immsrc,regw,regsrc,aluop} = control; 
  always @*
  if(aluop)begin
  case(funct[4:1])
    4'd4 :  alucontrol=0;   
    4'd2 :  alucontrol=1;   
    4'd0 :  alucontrol=2;   
    4'd12:  alucontrol=3;   
    4'd10:  alucontrol=1;   
    default:alucontrol=2'bxx;
  endcase
   flagw[1]=funct[0];        
   flagw[0] = funct[0] & (alucontrol == 0 | alucontrol == 1);     
  end
else begin          
   flagw=0;
   alucontrol=0; 
 end   
 assign pcs =((rd == 15) & regw) | branch ;        
 assign nowrite = (funct[4:1]==10);       
endmodule