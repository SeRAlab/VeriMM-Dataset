module top_module(
    output reg zero,
    output reg [31:0] aluRes,
    input [31:0] input1,
    input [31:0] input2,
    input [3:0] aluCtr
    );always @ (input1 or input2 or aluCtr)
    begin
        case (aluCtr)
            4'b0010: // Addition
                begin
                    aluRes = input1 + input2;
                    zero = (aluRes == 0) ? 1 : 0;
                end
            4'b0110: // Subtraction
                begin
                    aluRes = input1 - input2;
                    zero = (aluRes == 0) ? 1 : 0;
                end
            4'b0000: // Bitwise AND
                begin
                    aluRes = input1 & input2;
                    zero = (aluRes == 0) ? 1 : 0;
                end
            4'b0001: // Bitwise OR
                begin
                    aluRes = input1 | input2;
                    zero = (aluRes == 0) ? 1 : 0;
                end
            4'b0111: // Set Less Than
                begin
                    aluRes = (input1 < input2) ? 1 : 0;
                    zero = (aluRes == 0) ? 1 : 0;
                end
            4'b1100: // Bitwise NOR
                begin
                    aluRes = ~(input1 | input2);
                    zero = (aluRes == 0) ? 1 : 0;
                end
            default:
                begin
                    aluRes = 0;
                    zero = 1;
                end
        endcase
    end
endmodule