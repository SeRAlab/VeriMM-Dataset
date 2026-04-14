module top_module(A, B, ZF, OF, F, ALU_OP);input [3:0] A, B;
    input [2:0] ALU_OP;
    output reg [3:0] F;
    output reg ZF, OF;

    always @(*)
    begin
        case(ALU_OP)
            3'b000: // AND
                begin
                    F = A & B;
                    ZF = (F == 0) ? 1 : 0;
                    OF = 0;
                end
            3'b001: // OR
                begin
                    F = A | B;
                    ZF = (F == 0) ? 1 : 0;
                    OF = 0;
                end
            3'b010: // XOR
                begin
                    F = A ^ B;
                    ZF = (F == 0) ? 1 : 0;
                    OF = 0;
                end
            3'b011: // NOR
                begin
                    F = ~(A | B);
                    ZF = (F == 0) ? 1 : 0;
                    OF = 0;
                end
            3'b100: // ADD
                begin
                    {OF, F} = A + B;
                    ZF = (F == 0) ? 1 : 0;
                end
            3'b101: // SUB
                begin
                    {OF, F} = A + ~B + 1;
                    ZF = (F == 0) ? 1 : 0;
                end
            3'b110: // SET IF LESS THAN
                begin
                    F = (A < B) ? 4'b0001 : 4'b0000;
                    ZF = (F == 0) ? 1 : 0;
                    OF = 0;
                end
            3'b111: // SHIFT LEFT LOGICAL
                begin
                    F = B << A;
                    ZF = (F == 0) ? 1 : 0;
                    OF = 0;
                end
            default: // Invalid ALU_OP
                begin
                    F = 4'b0000;
                    ZF = 1;
                    OF = 0;
                end
        endcase
    end
endmodule