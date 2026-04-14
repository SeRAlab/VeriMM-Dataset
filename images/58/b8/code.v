module top_module (
    input g,
    input w,
    input k,
    input t,
    output reg x
);
    always @(*) begin
        case ({g, w, k, t})
            4'b0111: x = 1'b1;
            4'b0011: x = 1'b0;
            4'b1100: x = 1'b0;
            4'b0110: x = 1'b1;
            4'b0010: x = 1'b1;
            4'b0000: x = 1'b0;
            4'b1101: x = 1'b1;
            4'b0100: x = 1'b1;
            4'b1011: x = 1'b0;
            4'b0101: x = 1'b0;
            4'b0001: x = 1'b1;
            4'b1000: x = 1'b0;
            4'b1010: x = 1'b0;
            4'b1111: x = 1'b1;
            4'b1001: x = 1'b0;
            4'b1110: x = 1'b0;
        endcase
    end
endmodule
