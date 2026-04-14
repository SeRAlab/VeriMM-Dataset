module dvfs_controller (
    input [3:0] workload,
    output reg [1:0] frequency,
    output reg [1:0] voltage
);

always @(workload) begin
    case (workload)
        4'b0000, 4'b0001, 4'b0010, 4'b0011: begin
            frequency = 2'b00; // 1 MHz
            voltage = 2'b00;   // 1 V
        end
        4'b0100, 4'b0101, 4'b0110, 4'b0111: begin
            frequency = 2'b01; // 5 MHz
            voltage = 2'b01;   // 1.2 V
        end
        4'b1000, 4'b1001, 4'b1010, 4'b1011: begin
            frequency = 2'b10; // 10 MHz
            voltage = 2'b10;   // 1.5 V
        end
        4'b1100, 4'b1101, 4'b1110, 4'b1111: begin
            frequency = 2'b11; // 20 MHz
            voltage = 2'b11;   // 1.8 V
        end
        default: begin
            frequency = 2'b00; // Default to 1 MHz
            voltage = 2'b00;   // Default to 1 V
        end
    endcase
end

endmodule