module top_module(
    input [1:0] a,b,c,d,
    input [1:0] sel,
    output [1:0] mux_out,
    output [1:0] adder_out,
    output [1:0] final_output
);// 4-to-1 multiplexer module
    reg [1:0] mux_input;
    always @(*) begin
        case(sel)
            2'b00: mux_input = a;
            2'b01: mux_input = b;
            2'b10: mux_input = c;
            2'b11: mux_input = d;
        endcase
    end
    assign mux_out = mux_input;

    // 2-bit adder module
    wire [1:0] adder_input = {mux_input, b};
    wire [1:0] sum = adder_input + 2'b01;
    assign adder_out = sum;

    // Functional module for XOR operation
    wire [1:0] xor_output = mux_out ^ adder_out;
    assign final_output = xor_output;

endmodule