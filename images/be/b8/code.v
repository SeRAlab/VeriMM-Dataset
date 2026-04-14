module top_module(A, B, opcode, out);input[31:0] A, B;
    input [2:0] opcode;
    output [31:0] out;
    reg [31:0] out;

    parameter add = 3'b010, sub = 3'b110, slt = 3'b111, bne = 3'b011;

    always @ (A or B or opcode) begin
        casex (opcode)
            add: out = A + B;
            sub: out = A - B;
            bne: out = ~(A - B);
            slt: out = (A < B) ? 1 : 0;
            default: out = 31'b0;
        endcase
    end

endmodule