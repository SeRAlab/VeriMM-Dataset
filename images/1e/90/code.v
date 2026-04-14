module VCO(
    input wire clk,
    input wire reset,
    input wire [3:0] control_voltage, // 4-bit control voltage
    output reg [15:0] frequency // 16-bit frequency output
);
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            frequency <= 16'b0; // Reset frequency to 0
        end else begin
            frequency <= control_voltage * 1_000_000; // Frequency in Hz based on control voltage
        end
    end
endmodule