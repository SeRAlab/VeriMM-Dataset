module top_module(
    input wire [7:0] input1,
    input wire [7:0] input2,
    input wire [7:0] input3,
    input wire [7:0] input4,
    input wire sel_b1,
    input wire sel_b2,
    input wire [15:0] in,
    output wire [7:0] out_hi,
    output wire [7:0] out_lo,
    output wire [7:0] out_xor
);// 4-to-1 multiplexer
    wire [7:0] mux_out;
    assign mux_out = (sel_b1 == 0 && sel_b2 == 0) ? input1 :
                     (sel_b1 == 0 && sel_b2 == 1) ? input2 :
                     (sel_b1 == 1 && sel_b2 == 0) ? input3 :
                                                  input4;

    // Barrel shifter
    wire [7:0] in_hi = in[15:8];
    wire [7:0] in_lo = in[7:0];
    wire [7:0] shifted_hi;
    wire [7:0] shifted_lo;
    assign shifted_hi = in_hi >> 1;
    assign shifted_lo = in_lo << 1;

    // XOR module
    wire [7:0] xor_out;
    assign xor_out = mux_out ^ {shifted_hi, shifted_lo};

    // Output assignments
    assign out_hi = shifted_hi;
    assign out_lo = shifted_lo;
    assign out_xor = xor_out;

endmodule