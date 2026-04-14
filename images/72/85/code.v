module top_module( 
    input [7:0] Seg_RT, 
    input [7:0] Min_RT, 
    input [7:0] Hor_RT,
    input [7:0] Dia,
    input [7:0] Mes,
    input [7:0] Ao,
    output [7:0] Dato_Reg, 
    input [3:0] Selector 
    );reg [7:0]WE1;
   always @(Selector,Seg_RT,Min_RT,Hor_RT,Dia,Mes,Ao) 
      case (Selector)
         4'b0000: WE1 = Seg_RT;
         4'b0001: WE1 = Min_RT;
         4'b0010: WE1 = Hor_RT;
         4'b0011: WE1 = Dia;
			4'b0100: WE1 = Mes;
         4'b0101: WE1 = Ao;
         4'b0110: WE1 = Seg_RT;
         4'b0111: WE1 = Min_RT;
			4'b1000: WE1 = Hor_RT;
			default: WE1 = 8'd0; 
      endcase
					
assign Dato_Reg=WE1;

endmodule