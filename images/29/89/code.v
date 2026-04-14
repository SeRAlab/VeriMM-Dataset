module VCO (
    input wire clk,
    input wire [3:0] V_control,
    output reg [15:0] F_out
);
    parameter Frequency_base = 10_000_000; // 10 MHz
    parameter Multiplier = 1_000_000; // 1 MHz
    
    always @(posedge clk) begin
        F_out <= (Frequency_base + V_control) * Multiplier;
    end
endmodule