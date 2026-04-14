module top_module (
    input [3:0] k,
    output reg m
);

    always @(*) begin
        case (k)
            4'b0000: m = 0;
            4'b0001: m = 1;
            4'b0010: m = 0;
            4'b0011: m = 1;
            4'b0100: m = 1;
            4'b0101: m = 1;
            4'b0110: m = 0;
            4'b0111: m = 1;
            4'b1000: m = 0;
            4'b1001: m = 1;
            4'b1010: m = 0;
            4'b1011: m = 1;
            4'b1100: m = 1;
            4'b1101: m = 1;
            4'b1110: m = 0;
            4'b1111: m = 1;
            default: m = 0; // Default case
        endcase
    end
endmodule