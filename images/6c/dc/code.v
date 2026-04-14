module top_module (
    input [3:0] g,
    output reg h
);

    always @(*) begin
        case (g)
            4'b0000: h = 0;
            4'b0001: h = 1;
            4'b0010: h = 0;
            4'b0011: h = 1;
            4'b0100: h = 0;
            4'b0101: h = 1;
            4'b0110: h = 0;
            4'b0111: h = 1;
            4'b1000: h = 1;
            4'b1001: h = 0;
            4'b1010: h = 1;
            4'b1011: h = 0;
            4'b1100: h = 1;
            4'b1101: h = 0;
            4'b1110: h = 1;
            4'b1111: h = 0;
            default: h = 0; // Default case
        endcase
    end
endmodule