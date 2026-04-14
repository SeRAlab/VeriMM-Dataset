module top_module(ALUOp, funct, ALUctl);input wire [1:0] ALUOp;
input wire [5:0] funct;
output reg [3:0] ALUctl;

always @(*) begin
case (ALUOp)
    (2'b00): 
    begin
        case (funct)
            (6'b001000): ALUctl = 4'b0010;  
            (6'b001100): ALUctl = 4'b0000;  
        endcase
    end
    (2'b11): ALUctl = 4'b0010;              
    (2'b01): ALUctl = 4'b0110;              
    (2'b10):
    begin
        case (funct)
            (6'b100000): ALUctl = 4'b0010;  
            (6'b100010): ALUctl = 4'b0110;  
            (6'b100100): ALUctl = 4'b0000;  
            (6'b100101): ALUctl = 4'b0001;  
            (6'b101010): ALUctl = 4'b0111;  
        endcase
    end
endcase
end
endmodule