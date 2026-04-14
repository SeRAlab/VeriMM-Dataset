module top_module (
    input [2:0] p,
    output reg z
);

    always @(*) begin
        case (p)
            3'b000: z = 1;
            3'b001: z = 1;
            3'b010: z = 0;
            3'b011: z = 1;
            3'b100: z = 1;
            3'b101: z = 0;
            3'b110: z = 1;
            3'b111: z = 0;
            default: z = 0; // Default case
        endcase
    end
endmodule