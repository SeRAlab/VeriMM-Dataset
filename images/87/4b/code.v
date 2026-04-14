module top_module (
    input [2:0] h,
    output reg i
);

    always @(*) begin
        case (h)
            3'b000: i = 1;
            3'b001: i = 0;
            3'b010: i = 1;
            3'b011: i = 1;
            3'b100: i = 0;
            3'b101: i = 1;
            3'b110: i = 0;
            3'b111: i = 0;
            default: i = 0; // Default case
        endcase
    end
endmodule