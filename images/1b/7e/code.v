module DVFS_Controller (
    input [1:0] workload,
    output reg [1:0] frequency,
    output reg [1:0] voltage
);
    always @(*) begin
        case (workload)
            2'b00: begin
                frequency = 2'b00; // Frequency level 0
                voltage = 2'b00;   // Voltage level 0
            end
            2'b01: begin
                frequency = 2'b01; // Frequency level 1
                voltage = 2'b01;   // Voltage level 1
            end
            2'b10: begin
                frequency = 2'b10; // Frequency level 2
                voltage = 2'b10;   // Voltage level 2
            end
            2'b11: begin
                frequency = 2'b11; // Frequency level 3
                voltage = 2'b11;   // Voltage level 3
            end
            default: begin
                frequency = 2'b00; // Default to level 0
                voltage = 2'b00;   // Default to level 0
            end
        endcase
    end
endmodule