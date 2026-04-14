module top_module(
    input [3:0] sel, in0, in1, in2, in3, in4, in5,
    output reg [3:0] mux_out
);always @ (sel) begin
    case (sel)
        4'h0: mux_out = in0;
        4'h1: mux_out = in1;
        4'h2: mux_out = in2;
        4'h3: mux_out = in3;
        4'h4: mux_out = in4;
        4'h5: mux_out = in5;
        default: mux_out = 4'h0;
    endcase
end

endmodule