module q_module (
    input [1:0] s,
    output reg e
);

    always @(*) begin
        case (s)
            2'b00: e = 0;
            2'b01: e = 1;
            2'b10: e = 0;
            2'b11: e = 1;
            default: e = 0; // Default case
        endcase
    end
endmodule