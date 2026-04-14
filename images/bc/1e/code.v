module mux_2to1(
    input in0,          // 1-bit input.
    input in1,          // 1-bit input.
    input sel,          // 1-bit select signal.
    input en,           // Enable signal to activate the multiplexer.

    output out          // 1-bit output.
);

reg out_r;

//------------------------------------------------
// Multiplexer logic
always @(*) begin
    if (en) begin
        case (sel)
            1'b0: out_r = in0;
            1'b1: out_r = in1;
            default: out_r = 1'b0;
        endcase
    end else begin
        out_r = 1'b0;
    end
end

assign out = out_r;

endmodule