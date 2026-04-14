module mux2to1_singlebit (
    input sel,
    input in0,
    input in1,
    output out
);

    reg mux_out;  // Multiplexer output register

    always @(*) begin
        case (sel)
            1'b0: mux_out = in0;
            1'b1: mux_out = in1;
            default: mux_out = 1'b0;  // Default case (should not occur)
        endcase
    end

    assign out = mux_out;

endmodule