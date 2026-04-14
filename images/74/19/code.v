module u_module (
    input [2:0] k,
    output reg r
);

    always @(*) begin
        case (k)
            3'b000: r = 1;
            3'b001: r = 0;
            3'b010: r = 1;
            3'b011: r = 0;
            3'b100: r = 1;
            3'b101: r = 0;
            3'b110: r = 1;
            3'b111: r = 0;
            default: r = 0; // Default case
        endcase
    end
endmodule