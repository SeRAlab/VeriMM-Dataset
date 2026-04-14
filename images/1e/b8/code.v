module DVFS_Controller (
    input wire clk,
    input wire reset,
    input wire [1:0] voltage_level, // 00: Low, 01: Medium, 10: High
    output reg frequency_signal,      // Indicates current frequency level
    output reg [1:0] current_frequency // 00: Low Frequency, 01: Medium Frequency, 10: High Frequency
);

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            frequency_signal <= 0;
            current_frequency <= 2'b00;
        end else begin
            case (voltage_level)
                2'b00: begin
                    frequency_signal <= 1'b0; // Low Frequency
                    current_frequency <= 2'b00;
                end
                2'b01: begin
                    frequency_signal <= 1'b1; // Medium Frequency
                    current_frequency <= 2'b01;
                end
                2'b10: begin
                    frequency_signal <= 1'b1; // High Frequency
                    current_frequency <= 2'b10;
                end
                default: begin
                    frequency_signal <= 1'b0; // Default to Low Frequency
                    current_frequency <= 2'b00;
                end
            endcase
        end
    end
endmodule