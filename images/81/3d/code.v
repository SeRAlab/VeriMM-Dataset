module top_module(
    input [5:0] Op,
    input [5:0] Func,
    output reg RegWrite,
    output reg [3:0] ALUCntl 
    );always@(*) begin
        if (Op == 6'b0) begin
            RegWrite = 1'b1;
            case (Func)
                6'h20: ALUCntl = 4'b1010;
                6'h21: ALUCntl = 4'b0010;
                6'h22: ALUCntl = 4'b1110;
                6'h23: ALUCntl = 4'b0110;
                6'h24: ALUCntl = 4'b0000;
                6'h25: ALUCntl = 4'b0001;
                6'h26: ALUCntl = 4'b0011;
                6'h27: ALUCntl = 4'b1100;
                6'h2A: ALUCntl = 4'b0101; 
                6'h2B: ALUCntl = 4'b1111; 
                default: ALUCntl = 4'b0000; 
            endcase
        end
        else begin  
            RegWrite = 1'b0;
            ALUCntl = 4'b0;
        end
    end
endmodule