module top_module (
    input [1:0] x,
    output reg z
);

    always @(*) begin
        case (x)
            2'b00: z = 0;
            2'b01: z = 1;
            2'b10: z = 0;
            2'b11: z = 1;
            default: z = 0; // Default case
        endcase
    end
endmodule