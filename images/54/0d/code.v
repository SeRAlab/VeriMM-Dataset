module top_module (
    input [2:0] s,
    output reg c
);

    always @(*) begin
        case (s)
            3'b000: c = 1;
            3'b001: c = 0;
            3'b010: c = 1;
            3'b011: c = 0;
            3'b100: c = 1;
            3'b101: c = 0;
            3'b110: c = 1;
            3'b111: c = 0;
            default: c = 0; // Default case
        endcase
    end
endmodule