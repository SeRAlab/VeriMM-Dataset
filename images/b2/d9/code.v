module top_module(
               src1,       
               src2,       
               less,       
               A_invert,   
               B_invert,   
               cin,        
               operation,  
               result,     
               p,
               g,
               equal,
);input         src1;
input         src2;
input         less;
input 	     A_invert;
input         B_invert;
input         cin;
input [1:0]   operation;

output        result;

reg 		     result;


output        p;
output        g;
output        equal;

wire          input1,input2;
wire 	        And, Or, Add;
 
assign input1 = A_invert ^ src1;
assign input2 = B_invert ^ src2;
assign equal = input1 ^ input2;
assign And = input1 & input2;      
assign Or  = input1 | input2;      
assign Add = equal ^ cin;
assign p = Or;
assign g = And;

always@( * ) begin
   case (operation)
      2'b00 : result = And;
      2'b01 : result = Or;
      2'b10 : result = Add;
      2'b11 : result = less;
   endcase
end

endmodule