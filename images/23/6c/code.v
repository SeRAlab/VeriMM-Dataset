module DVFS_Controller (
    input clk,
    input enable,
    input [1:0] performance_level,
    output reg [1:0] voltage,   // 2-bit voltage level
    output reg [2:0] frequency   // 3-bit frequency level
);
    
    always @(posedge clk) begin
        if (enable) begin
            case (performance_level)
                2'b00: begin
                    voltage <= 2'b00;  // Lowest Voltage
                    frequency <= 3'b000; // Lowest Frequency
                end
                2'b01: begin
                    voltage <= 2'b01;  // Medium Voltage
                    frequency <= 3'b001; // Medium Frequency
                end
                2'b10: begin
                    voltage <= 2'b10;  // High Voltage
                    frequency <= 3'b010; // High Frequency
                end
                2'b11: begin
                    voltage <= 2'b11;  // Maximum Voltage
                    frequency <= 3'b011; // Maximum Frequency
                end
                default: begin
                    voltage <= 2'b00;  // Default to Lowest
                    frequency <= 3'b000; // Default to Lowest
                end
            endcase
        end
    end
endmodule