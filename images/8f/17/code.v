module top_module (
    input [3:0] q,
    output reg w
);

    always @(*) begin
        case (q)
            4'b0000: w = 1;
            4'b0001: w = 1;
            4'b0010: w = 0;
            4'b0011: w = 1;
            4'b0100: w = 0;
            4'b0101: w = 1;
            4'b0110: w = 0;
            4'b0111: w = 1;
            4'b1000: w = 0;
            4'b1001: w = 1;
            4'b1010: w = 0;
            4'b1011: w = 1;
            4'b1100: w = 0;
            4'b1101: w = 1;
            4'b1110: w = 0;
            4'b1111: w = 1;
            default: w = 0; // Default case
        endcase
    end
endmodule