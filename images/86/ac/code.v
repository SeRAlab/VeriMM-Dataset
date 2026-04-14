module top_module(
    input a, b, // input for the NOR gate module
    input sel, // select input for the multiplexer
    output reg [1:0] sum // output from the adder
);// NOR gate module
    wire nor_out;
    nor n1 (nor_out, a, b);

    // 2-bit multiplexer
    wire [1:0] mux_out;
    assign mux_out = sel ? 2'b11 : nor_out;

    // 2-bit adder
    always @ (mux_out) begin
        sum = mux_out + 2'b10;
    end

endmodule