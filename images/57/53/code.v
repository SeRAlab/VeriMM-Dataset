module top_module (
    input [3:0] r,
    output reg b
);

    always @(*) begin
        case (r)
            4'b0000: b = 1;
            4'b0001: b = 0;
            4'b0010: b = 1;
            4'b0011: b = 0;
            4'b0100: b = 1;
            4'b0101: b = 0;
            4'b0110: b = 1;
            4'b0111: b = 0;
            4'b1000: b = 1;
            4'b1001: b = 0;
            4'b1010: b = 1;
            4'b1011: b = 0;
            4'b1100: b = 1;
            4'b1101: b = 0;
            4'b1110: b = 1;
            4'b1111: b = 0;
            default: b = 0; // Default case
        endcase
    end
endmodule