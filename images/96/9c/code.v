module top_module(out, mcand, code);output reg [25:0] out;
    input [24:0] mcand;
    input [2:0] code;

    always @(mcand, code)
        case (code)
            3'b000 : out = 26'b0;
            3'b001 : out = {mcand[24], mcand};
            3'b010 : out = {mcand[24], mcand};
            3'b011 : out = {mcand, 1'b0};
            3'b100 : out = -{mcand, 1'b0};
            3'b101 : out = -{mcand[24], mcand};
            3'b110 : out = -{mcand[24], mcand};
            3'b111 : out = 26'b0;
        endcase

endmodule