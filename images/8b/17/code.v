module top_module (
    input [2:0] d,
    output reg v
);

    always @(*) begin
        case (d)
            3'b000: v = 0;
            3'b001: v = 1;
            3'b010: v = 1;
            3'b011: v = 0;
            3'b100: v = 1;
            3'b101: v = 0;
            3'b110: v = 1;
            3'b111: v = 1;
            default: v = 0; // Default case
        endcase
    end
endmodule