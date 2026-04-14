module switching_regulator (
    input wire clk,
    input wire reset,
    input wire [2:0] control_signal, // control signal to adjust voltage
    output reg [7:0] output_voltage // 8-bit output voltage
);
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            output_voltage <= 8'b00000000; // Reset voltage to 0
        end else begin
            case (control_signal)
                3'b000: output_voltage <= output_voltage; // No change
                3'b001: output_voltage <= output_voltage + 8'b00000001; // Increase voltage
                3'b010: output_voltage <= output_voltage + 8'b00000010; // Increase voltage
                3'b011: output_voltage <= output_voltage - 8'b00000001; // Decrease voltage
                3'b100: output_voltage <= output_voltage - 8'b00000010; // Decrease voltage
                default: output_voltage <= output_voltage; // No change
            endcase
        end
    end
endmodule