module top_module(
    in0,
    in1,
    in2,
    in3,
    in4,
    in5,
    in6,
    out
);// Module ports
    input  in0;
    input  in1;
    input  in2;
    input  in3;
    input  in4;
    input  in5;
    input  in6;
    output out;

    // Local signals
    wire or0_out;
    wire or1_out;
    wire or2_out;
    wire or3_out;
    wire or4_out;
    wire or5_out;

    //                           Name          Output              Other arguments
    or                           or0          (or0_out           , in0, in1                 );
    or                           or1          (or1_out           , or0_out, in2            );
    or                           or2          (or2_out           , or1_out, in3            );
    or                           or3          (or3_out           , or2_out, in4            );
    or                           or4          (or4_out           , or3_out, in5            );
    or                           or5          (or5_out           , or4_out, in6            );
    buf                          buf0         (out               , or5_out                 );

endmodule