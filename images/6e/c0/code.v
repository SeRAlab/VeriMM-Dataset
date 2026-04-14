module top_module(
    input a, b,
    output xor_out, cout, sum);// Structural implementation of XOR gate using MUX
    wire mux_out;
    assign mux_out = (a ^ b) ? 1'b1 : 1'b0;
    assign xor_out = mux_out;

    // Half adder implementation using XOR and AND gates
    wire ha_xor_out, ha_and_out;
    assign ha_xor_out = a ^ b;
    assign ha_and_out = a & b;
    assign cout = ha_and_out;
    assign sum = ha_xor_out;

endmodule