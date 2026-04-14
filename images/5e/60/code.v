module top_module(
    input wire [15:0] in,
    input wire select,
    output wire [7:0] out_hi,
    output wire [7:0] out_lo
);wire [7:0] hi_shifted;
    wire [7:0] lo_shifted;
    wire [7:0] hi_out;
    wire [7:0] lo_out;

    // Barrel shifter for upper byte
    assign hi_shifted[0] = in[8];
    assign hi_shifted[1] = in[9];
    assign hi_shifted[2] = in[10];
    assign hi_shifted[3] = in[11];
    assign hi_shifted[4] = in[12];
    assign hi_shifted[5] = in[13];
    assign hi_shifted[6] = in[14];
    assign hi_shifted[7] = in[15];

    // Barrel shifter for lower byte
    assign lo_shifted[0] = in[1];
    assign lo_shifted[1] = in[2];
    assign lo_shifted[2] = in[3];
    assign lo_shifted[3] = in[4];
    assign lo_shifted[4] = in[5];
    assign lo_shifted[5] = in[6];
    assign lo_shifted[6] = in[7];
    assign lo_shifted[7] = in[0];

    // Complement output based on select input
    assign hi_out = select ? ~hi_shifted : ~lo_shifted;
    assign lo_out = select ? ~lo_shifted : ~hi_shifted;

    // Output to top module
    assign out_hi = hi_out;
    assign out_lo = lo_out;

endmodule