module dvfs_controller (
    input [2:0] voltage_level,
    input [1:0] load_condition,
    output reg [1:0] frequency_setting
);

always @(*) begin
    case (voltage_level)
        3'b000: frequency_setting = 2'b00; // Low voltage sets low frequency
        3'b001: begin // Medium voltage
            case (load_condition)
                2'b00: frequency_setting = 2'b00; // Low load
                2'b01: frequency_setting = 2'b01; // Medium load
                2'b10: frequency_setting = 2'b10; // High load
                default: frequency_setting = 2'b00; // Default to low
            endcase
        end
        3'b010: begin // High voltage
            case (load_condition)
                2'b00: frequency_setting = 2'b01; // Low load
                2'b01: frequency_setting = 2'b10; // Medium load
                2'b10: frequency_setting = 2'b10; // High load
                default: frequency_setting = 2'b01; // Default to medium
            endcase
        end
        default: frequency_setting = 2'b00; // Default case
    endcase
end
endmodule