module mux_4to1(
    input in0,           // 1-bit input.
    input in1,           // 1-bit input.
    input in2,           // 1-bit input.
    input in3,           // 1-bit input.
    input [1:0] sel,     // 2-bit select signal.
    input en_n,          // Active-low enable signal.

    output out           // 1-bit output.
);

reg out_r;

//------------------------------------------------
// 4-to-1 Multiplexer logic
always @(*) begin
    if (!en_n) begin
        case (sel)
            2'b00: out_r = in0;
            2'b01: out_r = in1;
            2'b10: out_r = in2;
            2'b11: out_r = in3;
            default: out_r = 1'b0;
        endcase
    end else begin
        out_r = 1'b0;
    end
end

assign out = out_r;

endmodule