module pll_2x (
    input wire clk_in,       // Input clock
    input wire rst_n,       // Active low reset
    output reg clk_out,     // Output clock
    output reg control_voltage // Control voltage for VCO
);

reg [1:0] phase_error; // Phase error signal
reg clk_out_tmp;

always @(posedge clk_in or negedge rst_n) begin
    if (!rst_n) begin
        phase_error <= 2'b00;
        control_voltage <= 0;
    end else begin
        // Example phase detection logic
        phase_error <= {phase_error[0], clk_out_tmp}; // Shift in new phase info
        control_voltage <= (phase_error[1] == 1) ? 1 : 0; // Simple control voltage based on phase error
    end
end

always @(posedge clk_in or negedge rst_n) begin
    if (!rst_n) begin
        clk_out_tmp <= 0;
    end else begin
        clk_out_tmp <= ~clk_out_tmp; // Toggle output clock
    end
end

always @(posedge clk_in or negedge rst_n) begin
    if (!rst_n) begin
        clk_out <= 0;
    end else begin
        clk_out <= clk_out_tmp; // Output the toggled clock
    end
end

endmodule