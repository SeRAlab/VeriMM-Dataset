module top_module(
    input wire [31:0] PCF,JalrTarget, BranchTarget, JalTarget,
    input wire BranchE,JalD,JalrE,
    output reg [31:0] PC_In
    );always@(*)
    begin
        case({ BranchE, JalrE, JalD })
            3'b100  :   PC_In <= BranchTarget;
            3'b101  :   PC_In <= BranchTarget;  
            3'b010  :   PC_In <= JalrTarget;
            3'b011  :   PC_In <= JalrTarget;    
            3'b001  :   PC_In <= JalTarget;
            3'b000  :   PC_In <= PCF + 4;
            default :   PC_In <= PCF;
        endcase
    end
endmodule