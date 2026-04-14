module DVFS_Controller (
    input wire [1:0] performance_level,
    output reg [3:0] frequency,
    output reg [3:0] voltage
);

always @(performance_level) begin
    case (performance_level)
        2'b00: begin
            frequency = 4'b0001; // Low Frequency
            voltage = 4'b0001;   // Low Voltage
        end
        2'b01: begin
            frequency = 4'b0010; // Medium Frequency
            voltage = 4'b0010;   // Medium Voltage
        end
        2'b10: begin
            frequency = 4'b0100; // High Frequency
            voltage = 4'b0100;   // High Voltage
        end
        2'b11: begin
            frequency = 4'b1000; // Max Frequency
            voltage = 4'b1000;   // Max Voltage
        end
        default: begin
            frequency = 4'b0000; // Default (should not happen)
            voltage = 4'b0000;   // Default (should not happen)
        end
    endcase
end

endmodule