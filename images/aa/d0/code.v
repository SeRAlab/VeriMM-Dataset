module top_module(SW,KEY,LEDR);input [9:0]SW;
 input [3:0] KEY;
 output [9:0] LEDR;
 wire w, clock,rest_b;
 reg [3:0] y_Q,Y_D;
 
 
 
 
 
 
 parameter A=4'b0000, B=4'b0001, C= 4'b0010, D = 4'b0011, E = 4'b0100, F=4'B0101, G=4'b0110; 
 assign w=SW[1];
 assign clock = KEY[0];
 assign reset_b = SW[0]; 
 
 
 always @(*) 
 begin 
 case(y_Q)
 A: begin 
 if (!w) Y_D = A; 
 else Y_D = B; 
 end
 B:begin 
 if(!w) Y_D = A; 
 else Y_D = C; 
 end 
 C: begin
 if(!w) Y_D=E;
 else Y_D=D;
 end
 D:begin
 if(!w) Y_D=E;
 else Y_D=F;
 end
 
 E:
 if(!w)
begin
 Y_D=A;
 end
 else
begin
 Y_D=G;
 end
 
 F:begin
 if(!w) Y_D=E;
 else Y_D=F;
 end
 
 G:begin 
 if(!w) Y_D=A;
 else Y_D=C;
 end
 
 
 
 
  default: Y_D = A; 
  endcase 
  end 
 
 

 always @(posedge clock)
 
 if(reset_b == 1'b0)
 begin
 y_Q <= 4'b0000;
 end
 else
begin
 y_Q <= Y_D;
 end 
 
 

assign out_light = ((y_Q == F) | (y_Q == G)); 
 assign LEDR[9] = out_light; 
 assign LEDR[3:0] = y_Q; 
 endmodule