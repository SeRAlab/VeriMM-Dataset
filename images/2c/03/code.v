module DVFS_Controller (
    input [1:0] workload,
    output reg [1:0] voltage,
    output reg [1:0] frequency
);
    always @(workload) begin
        case (workload)
            2'b00: begin
                voltage = 2'b00; // Low voltage
                frequency = 2'b00; // Low frequency
            end
            2'b01: begin
                voltage = 2'b01; // Medium voltage
                frequency = 2'b01; // Medium frequency
            end
            2'b10: begin
                voltage = 2'b10; // High voltage
                frequency = 2'b10; // High frequency
            end
            2'b11: begin
                voltage = 2'b10; // High voltage
                frequency = 2'b01; // Medium frequency
            end
            default: begin
                voltage = 2'b00; // Default to low
                frequency = 2'b00; // Default to low
            end
        endcase
    end
endmodule