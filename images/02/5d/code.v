module dvfs_controller (
    input wire clk,
    input wire [1:0] performance_level, // 2-bit input indicating performance level
    output reg [3:0] voltage,           // 4-bit output for voltage
    output reg [3:0] frequency          // 4-bit output for frequency
);

always @(posedge clk) begin
    case (performance_level)
        2'b00: begin
            voltage <= 4'b0001; // Low voltage
            frequency <= 4'b0001; // Low frequency
        end
        2'b01: begin
            voltage <= 4'b0010; // Medium voltage
            frequency <= 4'b0010; // Medium frequency
        end
        2'b10: begin
            voltage <= 4'b0100; // High voltage
            frequency <= 4'b0100; // High frequency
        end
        2'b11: begin
            voltage <= 4'b1000; // Maximum voltage
            frequency <= 4'b1000; // Maximum frequency
        end
        default: begin
            voltage <= 4'b0000; // Default to 0
            frequency <= 4'b0000; // Default to 0
        end
    endcase
end

endmodule