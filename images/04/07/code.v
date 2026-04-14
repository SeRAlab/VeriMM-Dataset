module dvfs_controller (
    input clk,
    input reset,
    input [1:0] workload, // Workload input (00: low, 01: medium, 10: high, 11: very high)
    output reg [1:0] frequency, // Frequency output (00: 0Hz, 01: 1Hz, 10: 2Hz, 11: 3Hz)
    output reg [1:0] voltage // Voltage output (00: 1.0V, 01: 1.2V, 10: 1.4V, 11: 1.6V)
);
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            frequency <= 2'b00;
            voltage <= 2'b00;
        end else begin
            case (workload)
                2'b00: begin
                    frequency <= 2'b00; // 0Hz
                    voltage <= 2'b00; // 1.0V
                end
                2'b01: begin
                    frequency <= 2'b01; // 1Hz
                    voltage <= 2'b01; // 1.2V
                end
                2'b10: begin
                    frequency <= 2'b10; // 2Hz
                    voltage <= 2'b10; // 1.4V
                end
                2'b11: begin
                    frequency <= 2'b11; // 3Hz
                    voltage <= 2'b11; // 1.6V
                end
                default: begin
                    frequency <= 2'b00; // Default to 0Hz
                    voltage <= 2'b00; // Default to 1.0V
                end
            endcase
        end
    end
endmodule