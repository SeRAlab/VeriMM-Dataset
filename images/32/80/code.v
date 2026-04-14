module DVFS_Controller (
    input [2:0] workload,
    output reg [1:0] freq_control,
    output reg [1:0] volt_control
);

always @(workload) begin
    case (workload)
        3'b000: begin
            freq_control = 2'b00; // Low frequency
            volt_control = 2'b00; // Low voltage
        end
        3'b001: begin
            freq_control = 2'b01; // Medium frequency
            volt_control = 2'b01; // Medium voltage
        end
        3'b010: begin
            freq_control = 2'b10; // High frequency
            volt_control = 2'b01; // Medium voltage
        end
        3'b011: begin
            freq_control = 2'b10; // High frequency
            volt_control = 2'b10; // High voltage
        end
        3'b100: begin
            freq_control = 2'b11; // Max frequency
            volt_control = 2'b10; // High voltage
        end
        default: begin
            freq_control = 2'b00; // Default to low
            volt_control = 2'b00; // Default to low
        end
    endcase
end
endmodule