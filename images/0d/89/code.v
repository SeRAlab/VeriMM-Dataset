module DVFS_Controller (
    input wire clk,
    input wire rst,
    input wire [1:0] perf_level,
    output reg [2:0] voltage,
    output reg [2:0] frequency
);

always @(posedge clk or posedge rst) begin
    if (rst) begin
        voltage <= 3'b000;
        frequency <= 3'b000;
    end else begin
        case (perf_level)
            2'b00: begin
                voltage <= 3'b000; // Voltage Level 0
                frequency <= 3'b000; // Frequency Level 0
            end
            2'b01: begin
                voltage <= 3'b010; // Voltage Level 1
                frequency <= 3'b010; // Frequency Level 1
            end
            2'b10: begin
                voltage <= 3'b100; // Voltage Level 2
                frequency <= 3'b100; // Frequency Level 2
            end
            2'b11: begin
                voltage <= 3'b111; // Voltage Level 3
                frequency <= 3'b111; // Frequency Level 3
            end
            default: begin
                voltage <= voltage; // Hold last value
                frequency <= frequency; // Hold last value
            end
        endcase
    end
end

endmodule