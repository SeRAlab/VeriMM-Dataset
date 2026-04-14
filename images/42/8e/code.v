module top_module(
        input [1:0] g,
        input p,
        output reg G);

    always_comb begin
        case ({g, p})
            3'b000: G = 1'b0;
            3'b001: G = 1'b1;
            3'b010: G = 1'b0;
            3'b011: G = 1'b0;
            3'b100: G = 1'b1;
            3'b101: G = 1'b0;
            3'b110: G = 1'b0;
            3'b111: G = 1'b1;
            default: G = 1'bx;
        endcase
    end
endmodule