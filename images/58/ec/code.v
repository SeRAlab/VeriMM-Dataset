module top_module (
    input [1:0] p,
    output reg x
);

    always @(*) begin
        case (p)
            2'b00: x = 1;
            2'b01: x = 0;
            2'b10: x = 1;
            2'b11: x = 0;
            default: x = 0; // Default case
        endcase
    end
endmodule