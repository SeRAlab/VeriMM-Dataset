module top_module (
    input [1:0] m,
    output reg n
);

    always @(*) begin
        case (m)
            2'b00: n = 1;
            2'b01: n = 0;
            2'b10: n = 1;
            2'b11: n = 1;
            default: n = 0; // Default case
        endcase
    end
endmodule