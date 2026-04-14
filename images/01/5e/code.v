module DVFS_Controller (
    input wire clk,
    input wire reset,
    input wire [7:0] temperature, // Temperature input in degrees Celsius
    output reg [7:0] voltage,      // Voltage output in mV
    output reg [7:0] frequency     // Frequency output in MHz
);

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            voltage <= 1000; // Default voltage 1.0V
            frequency <= 1000; // Default frequency 1.0GHz
        end else begin
            case (temperature)
                8'd0: begin
                    voltage <= 1000; // 1.0V
                    frequency <= 1000; // 1.0GHz
                end
                8'd25: begin
                    voltage <= 800; // 0.8V
                    frequency <= 800; // 0.8GHz
                end
                8'd70: begin
                    voltage <= 600; // 0.6V
                    frequency <= 600; // 0.6GHz
                end
                default: begin
                    if (temperature < 8'd25) begin
                        voltage <= 1000; // 1.0V
                        frequency <= 1000; // 1.0GHz
                    end else if (temperature < 8'd70) begin
                        voltage <= 800; // 0.8V
                        frequency <= 800; // 0.8GHz
                    end else begin
                        voltage <= 600; // 0.6V
                        frequency <= 600; // 0.6GHz
                    end
                end
            endcase
        end
    end

endmodule