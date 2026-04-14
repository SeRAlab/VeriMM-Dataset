module DVFS_Controller (
    input wire [3:0] workload,
    output reg [1:0] frequency,
    output reg [2:0] voltage
);
    always @(workload) begin
        case (workload)
            4'b0000, 4'b0001, 4'b0010, 4'b0011: begin
                frequency = 2'b00; // low frequency
                voltage = 3'b000; // low voltage
            end
            4'b0100, 4'b0101, 4'b0110, 4'b0111: begin
                frequency = 2'b01; // medium frequency
                voltage = 3'b001; // medium voltage
            end
            4'b1000, 4'b1001, 4'b1010, 4'b1011: begin
                frequency = 2'b10; // high frequency
                voltage = 3'b010; // high voltage
            end
            4'b1100, 4'b1101, 4'b1110, 4'b1111: begin
                frequency = 2'b11; // max frequency
                voltage = 3'b011; // max voltage
            end
            default: begin
                frequency = 2'b00; // default low frequency
                voltage = 3'b000; // default low voltage
            end
        endcase
    end
endmodule