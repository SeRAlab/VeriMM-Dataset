module top_module(input[3:0] h_p,input [3:0] v_p,output [4:0] num);reg[4:0] valor; 
 assign num=valor; 
 always @(*)begin 
 if (v_p==3'd0)begin 
  case (h_p) 
  3'd0:valor=5'd0; 
  3'd1:valor=5'd1; 
  3'd2:valor=5'd2; 
  3'd3:valor=5'd3; 
  default : valor = 5'd16; 
  endcase 
 end 
 if (v_p==3'd1)begin 
  case (h_p) 
  3'd0:valor=5'd4; 
  3'd1:valor=5'd5; 
  3'd2:valor=5'd6; 
  3'd3:valor=5'd7; 
  default : valor = 5'd16; 
  endcase 
  end 
 if (v_p==3'd2)begin 
  case (h_p) 
  3'd0:valor=5'd8; 
  3'd1:valor=5'd9; 
  3'd2:valor=5'd10; 
  3'd3:valor=5'd11; 
  default : valor = 5'd16; 
  endcase 
  end 
 if (v_p==3'd3)begin 
  case (h_p) 
  3'd0:valor=5'd12; 
  3'd1:valor=5'd13; 
  3'd2:valor=5'd14; 
  3'd3:valor=5'd15; 
  default : valor = 5'd16; 
  endcase 
 end 
 else valor=5'd16; 
 end 
 endmodule