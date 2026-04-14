module top_module(
    input wire [5:0] Funct,
    input wire [1:0] ALUOp,
    output reg [3:0] ALUCtrl
    );always @ (Funct, ALUOp) begin
        case(ALUOp)
            
            
            0 : ALUCtrl = 4'b0010;

            
            
            1 : ALUCtrl = 4'b0110;

            
            2 : case(Funct)
                    
                    32 : ALUCtrl = 4'b0010;

                    
                    34 : ALUCtrl = 4'b0110;

                    
                    36 : ALUCtrl = 4'b0000;

                    
                    37 : ALUCtrl = 4'b0001;

                    
                    42 : ALUCtrl = 4'b0111;

                    default: ALUCtrl = 4'bx;
                endcase

            default: ALUCtrl = 4'bx;
        endcase
    end  
endmodule