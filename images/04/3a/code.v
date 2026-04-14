module dvfs_controller (
    input clk,
    input rst_n,
    input [1:0] load, // 00: Low, 01: Medium, 10: High
    output reg [1:0] frequency, // 00: Low Freq, 01: Medium Freq, 10: High Freq
    output reg [1:0] voltage // 00: Low Volt, 01: Medium Volt, 10: High Volt
);

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            frequency <= 2'b00;
            voltage <= 2'b00;
        end else begin
            case (load)
                2'b00: begin // Low Load
                    frequency <= 2'b00; // Low Frequency
                    voltage <= 2'b00;   // Low Voltage
                end
                2'b01: begin // Medium Load
                    frequency <= 2'b01; // Medium Frequency
                    voltage <= 2'b01;   // Medium Voltage
                end
                2'b10: begin // High Load
                    frequency <= 2'b10; // High Frequency
                    voltage <= 2'b10;   // High Voltage
                end
                default: begin
                    frequency <= 2'b00; // Default to Low
                    voltage <= 2'b00;   // Default to Low
                end
            endcase
        end
    end
endmodule