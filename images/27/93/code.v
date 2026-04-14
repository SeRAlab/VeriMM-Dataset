module dvfs_controller (
    input wire clk,
    input wire reset,
    input wire req,
    input wire [3:0] target_voltage, // 4-bit voltage
    input wire [3:0] target_frequency, // 4-bit frequency
    output reg [3:0] current_voltage,
    output reg [3:0] current_frequency
);
    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            current_voltage <= 4'b0000; // Reset voltage
            current_frequency <= 4'b0000; // Reset frequency
        end else if (req) begin
            if (current_voltage < target_voltage) begin
                current_voltage <= current_voltage + 1;
            end else if (current_voltage > target_voltage) begin
                current_voltage <= current_voltage - 1;
            end
            
            if (current_frequency < target_frequency) begin
                current_frequency <= current_frequency + 1;
            end else if (current_frequency > target_frequency) begin
                current_frequency <= current_frequency - 1;
            end
        end
    end
endmodule