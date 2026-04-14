module DVFS_Controller (
    input wire clk,
    input wire reset,
    input wire [1:0] voltage_level, // 00: low, 01: medium, 10: high
    output reg [1:0] frequency_level // 00: low, 01: medium, 10: high
);

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            frequency_level <= 2'b00; // Set to low on reset
        end else begin
            case (voltage_level)
                2'b00: frequency_level <= 2'b00; // Low frequency
                2'b01: frequency_level <= 2'b01; // Medium frequency
                2'b10: frequency_level <= 2'b10; // High frequency
                default: frequency_level <= 2'b00; // Default to low frequency
            endcase
        end
    end
endmodule