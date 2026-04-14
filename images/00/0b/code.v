module DVFS_Controller(
    input wire [2:0] workload,
    output reg [3:0] voltage_level,
    output reg [2:0] frequency_level
);

always @(workload) begin
    case (workload)
        3'b000: begin
            voltage_level = 4'b0001; // Low voltage
            frequency_level = 3'b000; // Low frequency
        end
        3'b001: begin
            voltage_level = 4'b0010; // Medium-low voltage
            frequency_level = 3'b001; // Medium-low frequency
        end
        3'b010: begin
            voltage_level = 4'b0011; // Medium voltage
            frequency_level = 3'b010; // Medium frequency
        end
        3'b011: begin
            voltage_level = 4'b0100; // Medium-high voltage
            frequency_level = 3'b011; // Medium-high frequency
        end
        3'b100: begin
            voltage_level = 4'b0101; // High voltage
            frequency_level = 3'b100; // High frequency
        end
        default: begin
            voltage_level = 4'b0000; // Default case
            frequency_level = 3'b000; // Default case
        end
    endcase
end

endmodule