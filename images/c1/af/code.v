module eth_shiftreg(Clk, Reset, MdcEn_n, Mdi, Fiad, Rgad, CtrlData, WriteOp, ByteSelect, 
                    LatchByte, ShiftedBit, Prsd, LinkFail);
parameter Tp=1;
input       Clk;              
input       Reset;            
input       MdcEn_n;          
input       Mdi;              
input [4:0] Fiad;             
input [4:0] Rgad;             
input [15:0]CtrlData;         
input       WriteOp;          
input [3:0] ByteSelect;       
input [1:0] LatchByte;        
output      ShiftedBit;       
output[15:0]Prsd;             
output      LinkFail;         
reg   [7:0] ShiftReg;         
reg   [15:0]Prsd;
reg         LinkFail;
always @ (posedge Clk or posedge Reset) 
begin
  if(Reset)
    begin
      ShiftReg[7:0] <= #Tp 8'h0;
      Prsd[15:0] <= #Tp 16'h0;
      LinkFail <= #Tp 1'b0;
    end
  else
    begin
      if(MdcEn_n)
        begin 
          if(|ByteSelect)
            begin
              case (ByteSelect[3:0])
                4'h1 :    ShiftReg[7:0] <= #Tp {2'b01, ~WriteOp, WriteOp, Fiad[4:1]};
                4'h2 :    ShiftReg[7:0] <= #Tp {Fiad[0], Rgad[4:0], 2'b10};
                4'h4 :    ShiftReg[7:0] <= #Tp CtrlData[15:8];
                4'h8 :    ShiftReg[7:0] <= #Tp CtrlData[7:0];
                default : ShiftReg[7:0] <= #Tp 8'h0;
              endcase
            end 
          else
            begin
              ShiftReg[7:0] <= #Tp {ShiftReg[6:0], Mdi};
              if(LatchByte[0])
                begin
                  Prsd[7:0] <= #Tp {ShiftReg[6:0], Mdi};
                  if(Rgad == 5'h01)
                    LinkFail <= #Tp ~ShiftReg[1];  
                end
              else
                begin
                  if(LatchByte[1])
                    Prsd[15:8] <= #Tp {ShiftReg[6:0], Mdi};
                end
            end
        end
    end
end
assign ShiftedBit = ShiftReg[7];
endmodule