module top_module (
    input [1:0] a,
    output reg b
);

    always @(*) begin
        case (a)
            2'b00: b = 0;
            2'b01: b = 1;
            2'b10: b = 1;
            2'b11: b = 0;
            default: b = 0; // Default case
        endcase
    end
endmodule