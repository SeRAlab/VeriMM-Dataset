module top_module(
    sel,
    in0,
    in1,
    in2,
    in3,
    out
);// Module ports
    input [1:0] sel;
    input in0, in1, in2, in3;
    output out;

    // Local signals
    reg mux_out;

    // Implement the multiplexer using an always block
    always @ (sel, in0, in1, in2, in3) begin
        case (sel)
            2'b00: mux_out = in0;
            2'b01: mux_out = in1;
            2'b10: mux_out = in2;
            2'b11: mux_out = in3;
        endcase
    end

    // Assign the output signal to the selected input signal
    assign out = mux_out;

endmodule