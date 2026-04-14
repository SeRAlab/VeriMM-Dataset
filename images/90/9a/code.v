module top_module(
   input[6:0]op,
   output regwriteD,
   output branchD,
   output alusrcD,
   output reg_destD,
   output[1:0]aluop, 
   output memwriteD,
   output memtoregD);reg [7:0] controls;
 assign {regwriteD,reg_destD,alusrcD,branchD,memwriteD,memtoregD,aluop}=controls;
 
 always@(*)
 begin
    case(op)
    7'b0110011: controls<=8'b10010010;  
    7'b0010011: controls<=8'b10100000;  
    7'b0000011: controls<=8'b10100100;  
    7'b0100011: controls<=8'b00101000;  
    7'b1100011: controls<=8'b00010001;  
    default:    controls<=8'bxxxxxxxx;   
    endcase
 end
endmodule