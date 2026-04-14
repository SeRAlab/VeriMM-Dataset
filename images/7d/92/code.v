module custom_logic (
    input g,
    input h,
    input i,
    input j,
    output reg z);

    always @(*) begin
        case ({g, h, i, j})
            4'b1011: z = 1;
            4'b0101: z = 0;
            4'b1110: z = 0;
            4'b0010: z = 1;
            4'b1000: z = 0;
            4'b0111: z = 1;
            4'b1101: z = 0;
            4'b0001: z = 1;
            4'b1010: z = 1;
            4'b0110: z = 0;
            default: z = 0;
        endcase
    end
endmodule