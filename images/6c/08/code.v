module top_module (
    input [1:0] h,
    output reg k
);

    always @(*) begin
        case (h)
            2'b00: k = 0;
            2'b01: k = 1;
            2'b10: k = 1;
            2'b11: k = 1;
            default: k = 0; // Default case
        endcase
    end
endmodule