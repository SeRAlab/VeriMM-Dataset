module DVFS_Controller (
    input wire clk,
    input wire reset,
    input wire [1:0] performance_level,
    output reg [3:0] voltage, // 4 bits to represent voltage levels
    output reg [3:0] frequency // 4 bits to represent frequency levels
);

// Voltage and frequency levels as parameters
parameter VOLTAGE_LEVEL0 = 4'b0001; // 0.5V
parameter VOLTAGE_LEVEL1 = 4'b0010; // 0.8V
parameter VOLTAGE_LEVEL2 = 4'b0011; // 1.0V
parameter VOLTAGE_LEVEL3 = 4'b0100; // 1.2V

parameter FREQUENCY_LEVEL0 = 4'b0001; // 100MHz
parameter FREQUENCY_LEVEL1 = 4'b0010; // 200MHz
parameter FREQUENCY_LEVEL2 = 4'b0011; // 300MHz
parameter FREQUENCY_LEVEL3 = 4'b0100; // 400MHz

always @(posedge clk or posedge reset) begin
    if (reset) begin
        voltage <= VOLTAGE_LEVEL0;
        frequency <= FREQUENCY_LEVEL0;
    end else begin
        case (performance_level)
            2'b00: begin
                voltage <= VOLTAGE_LEVEL0;
                frequency <= FREQUENCY_LEVEL0;
            end
            2'b01: begin
                voltage <= VOLTAGE_LEVEL1;
                frequency <= FREQUENCY_LEVEL1;
            end
            2'b10: begin
                voltage <= VOLTAGE_LEVEL2;
                frequency <= FREQUENCY_LEVEL2;
            end
            2'b11: begin
                voltage <= VOLTAGE_LEVEL3;
                frequency <= FREQUENCY_LEVEL3;
            end
            default: begin
                voltage <= VOLTAGE_LEVEL0;
                frequency <= FREQUENCY_LEVEL0;
            end
        endcase
    end
end

endmodule