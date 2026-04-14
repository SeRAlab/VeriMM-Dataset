module top_module (
    input [1:0] c,
    output reg d
);

    always @(*) begin
        case (c)
            2'b00: d = 1;
            2'b01: d = 0;
            2'b10: d = 0;
            2'b11: d = 1;
            default: d = 0; // Default case
        endcase
    end
endmodule