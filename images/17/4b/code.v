module dvfs_controller (
    input wire [2:0] performance_level,
    output reg [3:0] voltage_out,
    output reg [3:0] frequency_out
);

always @(*) begin
    case (performance_level)
        3'b000: begin
            voltage_out = 4'b0001; // 1V
            frequency_out = 4'b0001; // 1GHz
        end
        3'b001: begin
            voltage_out = 4'b0010; // 1.5V
            frequency_out = 4'b0011; // 1.5GHz
        end
        3'b010: begin
            voltage_out = 4'b0011; // 2V
            frequency_out = 4'b0101; // 2GHz
        end
        3'b011: begin
            voltage_out = 4'b0100; // 2.5V
            frequency_out = 4'b0111; // 2.5GHz
        end
        3'b100: begin
            voltage_out = 4'b0101; // 3V
            frequency_out = 4'b1001; // 3GHz
        end
        default: begin
            voltage_out = 4'b0000; // Default case
            frequency_out = 4'b0000; // Default case
        end
    endcase
end

endmodule