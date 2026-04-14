module top_module (
    input [1:0] l,
    output reg v
);

    always @(*) begin
        case (l)
            2'b00: v = 0;
            2'b01: v = 1;
            2'b10: v = 0;
            2'b11: v = 1;
            default: v = 0; // Default case
        endcase
    end
endmodule