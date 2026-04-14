module top_module(
          funct_i,
          ALUOp_i,
          ALUCtrl_o
          );input      [6-1:0] funct_i;
input      [4-1:0] ALUOp_i;

output     [4-1:0] ALUCtrl_o;    
     

reg        [4-1:0] ALUCtrl_o;



       

always @(*) begin
    if (ALUOp_i != 4'b1111)
        ALUCtrl_o = ALUOp_i;
    else begin
        case (funct_i)
            3:       ALUCtrl_o = 14; 
            7:       ALUCtrl_o = 14; 
            32:      ALUCtrl_o = 2; 
            34:      ALUCtrl_o = 6; 
            36:      ALUCtrl_o = 0; 
            37:      ALUCtrl_o = 1; 
            42:      ALUCtrl_o = 7; 
            default: ALUCtrl_o = 4'b1111;
        endcase
    end
end

endmodule