module dvfs_controller(
    input wire [1:0] performance_level,
    output reg [3:0] frequency,  // Represent frequency in GHz (1-4)
    output reg [3:0] voltage      // Represent voltage in V (1.0-1.6)
);

always @(*) begin
    case (performance_level)
        2'b00: begin
            frequency = 4'b0001; // 1 GHz
            voltage = 4'b0001;   // 1.0 V
        end
        2'b01: begin
            frequency = 4'b0010; // 2 GHz
            voltage = 4'b0010;   // 1.2 V
        end
        2'b10: begin
            frequency = 4'b0011; // 3 GHz
            voltage = 4'b0011;   // 1.4 V
        end
        2'b11: begin
            frequency = 4'b0100; // 4 GHz
            voltage = 4'b0100;   // 1.6 V
        end
        default: begin
            frequency = 4'b0000; // Default to 0 GHz
            voltage = 4'b0000;   // Default to 0 V
        end
    endcase
end

endmodule