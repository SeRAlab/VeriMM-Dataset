module top_module(opCode, funCode, aluOp);input [3:0] opCode, funCode;
    output reg [2:0] aluOp;

    always @ (*) begin
        case(opCode)
            4'b0000: begin              
                if(funCode == 4'b0000)
                    aluOp = 3'b000;     
                if(funCode == 4'b0001)
                    aluOp = 3'b001;     
                if(funCode == 4'b0100)
                    aluOp = 3'b010;     
                if(funCode == 4'b0101)
                    aluOp = 3'b011;     
            end

            4'b0001: aluOp = 3'b100;    
            4'b0010: aluOp = 3'b101;    
            4'b1010: aluOp = 3'b110;    
            4'b1011: aluOp = 3'b110;    
            4'b1100: aluOp = 3'b110;    
            4'b1101: aluOp = 3'b110;    
            4'b1111: aluOp = 3'b111;    
            
            default: aluOp = 3'b111;
        endcase
    end
endmodule