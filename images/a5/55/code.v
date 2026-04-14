module top_module(
        input [1:0] k,
        input j,
        output reg K);

    always_comb begin
        case ({k, j})
            3'b000: K = 1'b0;
            3'b001: K = 1'b1;
            3'b010: K = 1'b0;
            3'b011: K = 1'b0;
            3'b100: K = 1'b1;
            3'b101: K = 1'b0;
            3'b110: K = 1'b0;
            3'b111: K = 1'b1;
            default: K = 1'bx;
        endcase
    end
endmodule