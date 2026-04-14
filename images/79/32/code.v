module top_module (
    input w,
    input g,
    input i,
    input h,
    output reg e
);
    always @(*) begin
        case ({w, g, i, h})
            4'b1111: e = 1'b0;
            4'b1110: e = 1'b0;
            4'b0010: e = 1'b1;
            4'b0110: e = 1'b0;
            4'b0000: e = 1'b1;
            4'b1001: e = 1'b0;
            4'b1011: e = 1'b1;
            4'b1100: e = 1'b0;
            4'b1000: e = 1'b1;
            4'b0001: e = 1'b0;
            4'b0101: e = 1'b1;
            4'b0111: e = 1'b0;
            4'b0100: e = 1'b1;
            4'b0011: e = 1'b1;
            4'b1010: e = 1'b1;
            4'b1101: e = 1'b0;
        endcase
    end
endmodule
