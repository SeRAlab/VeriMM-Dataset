module mux_8bit_2to1 (
    input [7:0] a,
    input [7:0] b,
    input sel,
    output reg [7:0] y
);

    // Multiplexer logic
    always @(*) begin
        case (sel)
            1'b0: y = a;
            1'b1: y = b;
            default: y = 8'b0;
        endcase
    end

endmodule