module top_module (
    input [1:0] h,
    output reg s
);

    always @(*) begin
        case (h)
            2'b00: s = 1;
            2'b01: s = 0;
            2'b10: s = 0;
            2'b11: s = 1;
            default: s = 0; // Default case
        endcase
    end
endmodule