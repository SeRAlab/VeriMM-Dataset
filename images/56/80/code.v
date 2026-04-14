module top_module (
    input [2:0] e,
    output reg f
);

    always @(*) begin
        case (e)
            3'b000: f = 1;
            3'b001: f = 1;
            3'b010: f = 0;
            3'b011: f = 0;
            3'b100: f = 1;
            3'b101: f = 1;
            3'b110: f = 0;
            3'b111: f = 0;
            default: f = 0; // Default case
        endcase
    end
endmodule