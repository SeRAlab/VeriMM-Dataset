module top_module (
    input [2:0] h,
    output reg s
);

    always @(*) begin
        case (h)
            3'b000: s = 0;
            3'b001: s = 1;
            3'b010: s = 0;
            3'b011: s = 1;
            3'b100: s = 1;
            3'b101: s = 0;
            3'b110: s = 1;
            3'b111: s = 0;
            default: s = 0; // Default case
        endcase
    end
endmodule