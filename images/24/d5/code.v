module dvfs_controller (
    input [1:0] control_signal,
    output reg [1:0] voltage,
    output reg [1:0] frequency
);
    always @(control_signal) begin
        case (control_signal)
            2'b00: begin
                voltage <= 2'b00; // Low voltage
                frequency <= 2'b00; // Low frequency
            end
            2'b01: begin
                voltage <= 2'b01; // Medium voltage
                frequency <= 2'b01; // Medium frequency
            end
            2'b10: begin
                voltage <= 2'b10; // High voltage
                frequency <= 2'b10; // High frequency
            end
            2'b11: begin
                voltage <= 2'bxx; // Reserved
                frequency <= 2'bxx; // Reserved
            end
            default: begin
                voltage <= 2'bxx; // Invalid state
                frequency <= 2'bxx; // Invalid state
            end
        endcase
    end
endmodule