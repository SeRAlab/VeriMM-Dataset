module top_module(
    input signed [17:0] phase_currents_0,
    input signed [17:0] phase_currents_1,
    output signed [17:0] alpha_current,
    output signed [17:0] beta_current
);wire signed [17:0] sqrt3 = 18102; // sqrt(3) in sfix18_En15 format

    // Corrected the calculation for beta_current
    assign alpha_current = (2 * phase_currents_0 - phase_currents_1) * 10923; // 2/3 in sfix18_En15 format
    assign beta_current = (phase_currents_1 + phase_currents_0) * 6055; // 1/sqrt(3) in sfix18_En15 format

endmodule