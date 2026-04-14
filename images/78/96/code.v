module top_module (
    input [1:0] j,
    output reg t
);

    always @(*) begin
        case (j)
            2'b00: t = 1;
            2'b01: t = 1;
            2'b10: t = 0;
            2'b11: t = 0;
            default: t = 0; // Default case
        endcase
    end
endmodule