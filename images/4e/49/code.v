module mux2to1_64bit (
    input sel,
    input [63:0] in0,
    input [63:0] in1,
    output [63:0] out
);

    reg [63:0] mux_out;  // Multiplexer output register

    always @(*) begin
        case (sel)
            1'b0: mux_out = in0;
            1'b1: mux_out = in1;
            default: mux_out = 64'b0000000000000000000000000000000000000000000000000000000000000000;  // Default case (should not occur)
        endcase
    end

    assign out = mux_out;

endmodule