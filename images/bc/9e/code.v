module top_module(
    clkin,
    phasectrlin,
    phaseinvertctrl,
    powerdown,
    clkout
);parameter use_phasectrlin = "true";
    parameter phase_setting = 0;
    parameter invert_phase = "false";
    parameter physical_clock_source = "auto";

    input [3:0] clkin;
    input [1:0] phasectrlin;
    input phaseinvertctrl;
    input powerdown;
    output reg clkout; // Changed to reg for assignment in always block

    wire [3:0] phase_adjusted_clk;

    // Phase adjustment based on phasectrlin
    assign phase_adjusted_clk[0] = clkin[phasectrlin[0]];
    assign phase_adjusted_clk[1] = clkin[phasectrlin[1]];
    assign phase_adjusted_clk[2] = clkin[phasectrlin[0] ^ phasectrlin[1]];
    assign phase_adjusted_clk[3] = clkin[phasectrlin[0] & phasectrlin[1]];

    // Phase adjustment based on phase_setting
    assign phase_adjusted_clk = (use_phasectrlin == "true") ? phase_adjusted_clk : {clkin[3:phase_setting+1], clkin[phase_setting:0]};

    // Phase inversion
    always @(*) begin
        if (invert_phase == "true") 
            clkout = ~phase_adjusted_clk;
        else 
            clkout = phase_adjusted_clk; 
    end

endmodule