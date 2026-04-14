module mux2to1_32bit (
    input sel,
    input [31:0] in0,
    input [31:0] in1,
    output [31:0] out
);

    reg [31:0] mux_out;  // Multiplexer output register

    always @(*) begin
        case (sel)
            1'b0: mux_out = in0;
            1'b1: mux_out = in1;
            default: mux_out = 32'b00000000000000000000000000000000;  // Default case (should not occur)
        endcase
    end

    assign out = mux_out;

endmodule