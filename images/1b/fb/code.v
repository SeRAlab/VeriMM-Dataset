module dvfs_controller (
    input wire [2:0] load,
    output reg [1:0] frequency,
    output reg [1:0] voltage
);

always @(load) begin
    case (load)
        3'b000, 3'b001, 3'b010: begin
            frequency = 2'b00; // Lowest frequency
            voltage = 2'b00;   // Lowest voltage
        end
        3'b011, 3'b100, 3'b101: begin
            frequency = 2'b01; // Medium frequency
            voltage = 2'b01;   // Medium voltage
        end
        3'b110, 3'b111: begin
            frequency = 2'b10; // Highest frequency
            voltage = 2'b10;   // Highest voltage
        end
        default: begin
            frequency = 2'b00; // Default to lowest
            voltage = 2'b00;   // Default to lowest
        end
    endcase
end

endmodule