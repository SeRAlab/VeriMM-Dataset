module top_module(a,b,op,opcode);output reg [7:0] op;     
   input [7:0]     a,b;    
   input [3:0] opcode;    
   
always @(*)
begin
 case (opcode)
   4'b0000 : begin op = a + b; end
   4'b0001 : begin op = a - b; end
   4'b0010 : begin op = a * b; end
   4'b0011 : begin op = a / b; end
   4'b0100 : begin op = a % b; end
   4'b0101 : begin op = a & b; end
   4'b0110 : begin op = a | b; end
   4'b0111 : begin op = a && b;end
   4'b1000 : begin op = a || b;end
   4'b1001 : begin op = a ^ b; end
   4'b1010 : begin op = ~ a;   end
   4'b1011 : begin op = ! a;   end
   4'b1100 : begin op = a >> 1;end
   4'b1101 : begin op = a << 1;end
   4'b1110 : begin op = a + 1; end
   4'b1111 : begin op = a - 1; end
   default:op = 8'bXXXXXXXX;
 endcase
end

endmodule