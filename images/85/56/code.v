module mux4to1_32bit (
    input [1:0] sel,
    input [31:0] in0,
    input [31:0] in1,
    input [31:0] in2,
    input [31:0] in3,
    output [31:0] out
);

    reg [31:0] mux_out;  // Multiplexer output register

    always @(*) begin
        case (sel)
            2'b00: mux_out = in0;
            2'b01: mux_out = in1;
            2'b10: mux_out = in2;
            2'b11: mux_out = in3;
            default: mux_out = 32'b0;  // Default case (should not occur)
        endcase
    end

    assign out = mux_out;

endmodule