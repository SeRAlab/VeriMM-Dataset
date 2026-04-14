module dvfs_controller (
    input [3:0] temperature, // 4-bit temperature input
    output reg [1:0] voltage, // 2-bit voltage output
    output reg [1:0] frequency // 2-bit frequency output
);

always @(*) begin
    case (temperature)
        4'b0000, 4'b0001: begin
            voltage = 2'b00; // Low Voltage
            frequency = 2'b00; // Low Frequency
        end
        4'b0010, 4'b0011: begin
            voltage = 2'b01; // Medium Voltage
            frequency = 2'b01; // Medium Frequency
        end
        4'b0100, 4'b0101: begin
            voltage = 2'b10; // High Voltage
            frequency = 2'b10; // High Frequency
        end
        default: begin
            voltage = 2'b11; // Default Voltage (Shutdown)
            frequency = 2'b11; // Default Frequency (Shutdown)
        end
    endcase
end

endmodule