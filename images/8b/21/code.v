module top_module(input [1:0] ALUOp,
input [2:0]inst1412,
input inst30,
output reg [3:0] sel);always @ * begin
        case (ALUOp)       
        2'b00 : sel = 4'b00_00;
        2'b01 : sel = 4'b00_01;
        2'b10 : begin
        if(inst1412==0 && inst30==0)
            sel = 4'b00_00;
        else if(inst1412==0 && inst30==1)
            sel = 4'b00_01; 
        else if(inst1412==1)
            sel = 4'b10_01;
        else if(inst1412==2)
            sel = 4'b11_01;
        else if(inst1412==3)
            sel = 4'b11_11;
        else if(inst1412==4)
            sel = 4'b01_11;
         else if(inst1412==5 && inst30==0)
            sel = 4'b10_00;
        else if(inst1412==5 && inst30==1)
            sel = 4'b10_10;
        else if(inst1412==6)
            sel = 4'b01_00;
        else if(inst1412==7)
            sel = 4'b01_01;
        end
         endcase
        end
endmodule