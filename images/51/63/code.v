module top_module (
    input a,
    input g,
    input p,
    input e,
    output reg z
);
    always @(*) begin
        case ({a, g, p, e})
            4'b1011: z = 1'b0;
            4'b0011: z = 1'b0;
            4'b0100: z = 1'b1;
            4'b1001: z = 1'b1;
            4'b1000: z = 1'b0;
            4'b0010: z = 1'b0;
            4'b0111: z = 1'b1;
            4'b0110: z = 1'b0;
            4'b0001: z = 1'b1;
            4'b0000: z = 1'b0;
            4'b1010: z = 1'b0;
            4'b1110: z = 1'b1;
            4'b0101: z = 1'b0;
            4'b1101: z = 1'b1;
            4'b1111: z = 1'b1;
            4'b1100: z = 1'b1;
        endcase
    end
endmodule
