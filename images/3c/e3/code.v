module dvfs_controller(
    input clk,
    input reset,
    input [1:0] control_signal,
    output reg [1:0] voltage_level,
    output reg [1:0] frequency_level
);

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            voltage_level <= 2'b00;  // 0V
            frequency_level <= 2'b00; // 1GHz
        end else begin
            case (control_signal)
                2'b00: begin
                    voltage_level <= 2'b00;  // 0V
                    frequency_level <= 2'b00; // 1GHz
                end
                2'b01: begin
                    voltage_level <= 2'b01;  // 1V
                    frequency_level <= 2'b01; // 2GHz
                end
                2'b10: begin
                    voltage_level <= 2'b10;  // 2V
                    frequency_level <= 2'b10; // 3GHz
                end
                2'b11: begin
                    voltage_level <= 2'b00;  // 0V
                    frequency_level <= 2'b00; // 1GHz
                end
                default: begin
                    voltage_level <= 2'b00;  // reset to 0V
                    frequency_level <= 2'b00; // reset to 1GHz
                end
            endcase
        end
    end
endmodule