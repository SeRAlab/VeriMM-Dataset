module top_module (
    input [2:0] m,
    output reg w
);

    always @(*) begin
        case (m)
            3'b000: w = 1;
            3'b001: w = 0;
            3'b010: w = 1;
            3'b011: w = 0;
            3'b100: w = 0;
            3'b101: w = 1;
            3'b110: w = 0;
            3'b111: w = 1;
            default: w = 0; // Default case
        endcase
    end
endmodule