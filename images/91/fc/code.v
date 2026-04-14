module top_module(
    input  clk,   // clock
    input  ena,   // pulse enable
    output pulse, // pulse
    output cycle  // delayed clock
);reg pulse_reg, cycle_reg;

always @(posedge clk) begin
    // Delay the clock signal
    cycle_reg <= clk;
end

always @(posedge cycle_reg) begin
    // Generate the pulse signal
    if (ena) pulse_reg <= 1'b1;
    else pulse_reg <= 1'b0;
end

always @(posedge clk) begin
    // Reset the pulse signal
    if (ena && !pulse_reg) pulse_reg <= 1'b1;
    else pulse_reg <= 1'b0;
end

assign pulse = pulse_reg;
assign cycle = cycle_reg;

endmodule