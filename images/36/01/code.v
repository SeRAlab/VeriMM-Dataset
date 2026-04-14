module DVFS_Controller (
    input wire clk,
    input wire reset,
    input wire [1:0] workload,
    output reg [3:0] voltage_frequency
);

always @(posedge clk or posedge reset) begin
    if (reset) begin
        voltage_frequency <= 4'b0001; // Default to Low Voltage & Frequency
    end else begin
        case (workload)
            2'b00: voltage_frequency <= 4'b0001; // Low Voltage & Frequency
            2'b01: voltage_frequency <= 4'b0011; // Medium Voltage & Frequency
            2'b10: voltage_frequency <= 4'b0110; // High Voltage & Frequency
            2'b11: voltage_frequency <= 4'b1111; // Turbo Voltage & Frequency
            default: voltage_frequency <= 4'b0001; // Default case
        endcase
    end
end

endmodule