module mux2to1_16bit (
    input sel,
    input [15:0] in0,
    input [15:0] in1,
    output [15:0] out
);

    reg [15:0] mux_out;  // Multiplexer output register

    always @(*) begin
        case (sel)
            1'b0: mux_out = in0;
            1'b1: mux_out = in1;
            default: mux_out = 16'b0000000000000000;  // Default case (should not occur)
        endcase
    end

    assign out = mux_out;

endmodule