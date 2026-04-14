module dvfs_controller(
    input [4:0] workload,
    output reg [2:0] voltage,
    output reg [2:0] frequency
);
    always @(*) begin
        case (workload)
            5'b00000, 5'b00001, 5'b00010, 5'b00011, 5'b00100,
            5'b00101, 5'b00110, 5'b00111, 5'b01000, 5'b01001,
            5'b01010: begin
                voltage = 3'b000; // Voltage level 0
                frequency = 3'b000; // Frequency level 0
            end
            5'b01011, 5'b01100, 5'b01101, 5'b01110, 5'b01111,
            5'b10000, 5'b10001, 5'b10010: begin
                voltage = 3'b001; // Voltage level 1
                frequency = 3'b001; // Frequency level 1
            end
            5'b10011, 5'b10100, 5'b10101, 5'b10110, 5'b10111,
            5'b11000, 5'b11001, 5'b11010: begin
                voltage = 3'b010; // Voltage level 2
                frequency = 3'b010; // Frequency level 2
            end
            5'b11111: begin
                voltage = 3'b011; // Voltage level 3
                frequency = 3'b011; // Frequency level 3
            end
            default: begin
                voltage = 3'b000; // Default to level 0
                frequency = 3'b000; // Default to level 0
            end
        endcase
    end
endmodule