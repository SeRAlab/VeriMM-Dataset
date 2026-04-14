module top_module(
    input signed [31:0] F, // sfix32_En22
    input signed [17:0] param_open_loop_bias, // sfix18_En14
    input signed [17:0] param_open_loop_scalar, // sfix18_En16
    output signed [17:0] V // sfix18_En12
);wire signed [31:0] abs_F; // sfix32_En22
    wire signed [35:0] scaled_abs_F; // sfix36_En23
    wire signed [36:0] biased_scaled_abs_F; // sfix37_En23
    wire signed [17:0] V_dt; // sfix18_En12

    // Absolute value of F
    assign abs_F = (F < 32'sb0) ? -F : F;

    // Scale the absolute value of F
    assign scaled_abs_F = abs_F * param_open_loop_scalar;

    // Add the bias value to the scaled absolute value of F
    assign biased_scaled_abs_F = scaled_abs_F + {{10{param_open_loop_bias[17]}}, {param_open_loop_bias, 9'b000000000}};

    // Output the 18 most significant bits of the biased scaled absolute value of F as the output voltage
    assign V_dt = biased_scaled_abs_F[36:19];
    assign V = (biased_scaled_abs_F[36] == 1) ? -V_dt : V_dt;

endmodule