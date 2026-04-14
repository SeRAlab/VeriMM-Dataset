module top_module (
    input [1:0] c,
    output reg w
);

    always @(*) begin
        case (c)
            2'b00: w = 0;
            2'b01: w = 1;
            2'b10: w = 0;
            2'b11: w = 1;
            default: w = 0; // Default case
        endcase
    end
endmodule