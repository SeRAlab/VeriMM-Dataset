module mux_2to1 (
    input a,
    input b,
    input sel,
    output reg y
);

    // Multiplexer logic
    always @(*) begin
        case (sel)
            1'b0: y = a;
            1'b1: y = b;
            default: y = 1'b0;
        endcase
    end

endmodule