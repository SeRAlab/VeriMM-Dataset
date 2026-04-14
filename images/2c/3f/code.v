module LDO_Control (
    input wire [2:0] control_signal,
    output reg enable,
    output reg [2:0] output_voltage
);

always @(control_signal) begin
    case(control_signal)
        3'b000: begin
            enable = 1;
            output_voltage = 3'b001; // 1.2V
        end
        3'b001: begin
            enable = 1;
            output_voltage = 3'b010; // 1.5V
        end
        3'b010: begin
            enable = 1;
            output_voltage = 3'b011; // 1.8V
        end
        3'b011: begin
            enable = 0; // Disabled
            output_voltage = 3'b000; // 0V
        end
        default: begin
            enable = 0; // Disabled for control signals 100 and above
            output_voltage = 3'b000; // 0V
        end
    endcase
end

endmodule