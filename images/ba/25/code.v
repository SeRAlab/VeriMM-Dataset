module top_module (
    input [1:0] s,
    output reg a
);

    always @(*) begin
        case (s)
            2'b00: a = 0;
            2'b01: a = 1;
            2'b10: a = 1;
            2'b11: a = 0;
            default: a = 0; // Default case
        endcase
    end
endmodule