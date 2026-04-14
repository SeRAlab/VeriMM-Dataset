module mux2to1 (
    input sel,
    input [7:0] in0,
    input [7:0] in1,
    output [7:0] out
);

    reg [7:0] mux_out;  // Multiplexer output register

    always @(*) begin
        case (sel)
            1'b0: mux_out = in0;
            1'b1: mux_out = in1;
            default: mux_out = 8'b00000000;  // Default case (should not occur)
        endcase
    end

    assign out = mux_out;

endmodule