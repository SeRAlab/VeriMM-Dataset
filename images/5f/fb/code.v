module top_module (
    input [2:0] i,
    output reg o
);

    always @(*) begin
        case (i)
            3'b000: o = 1;
            3'b001: o = 1;
            3'b010: o = 0;
            3'b011: o = 1;
            3'b100: o = 0;
            3'b101: o = 1;
            3'b110: o = 0;
            3'b111: o = 0;
            default: o = 0; // Default case
        endcase
    end
endmodule