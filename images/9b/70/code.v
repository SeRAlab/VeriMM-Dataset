module j_module (
    input [1:0] u,
    output reg g
);

    always @(*) begin
        case (u)
            2'b00: g = 0;
            2'b01: g = 1;
            2'b10: g = 0;
            2'b11: g = 1;
            default: g = 0; // Default case
        endcase
    end
endmodule