module mux2to1_4bit (
    input sel,
    input [3:0] in0,
    input [3:0] in1,
    output [3:0] out
);

    reg [3:0] mux_out;  // Multiplexer output register

    always @(*) begin
        case (sel)
            1'b0: mux_out = in0;
            1'b1: mux_out = in1;
            default: mux_out = 4'b0000;  // Default case (should not occur)
        endcase
    end

    assign out = mux_out;

endmodule