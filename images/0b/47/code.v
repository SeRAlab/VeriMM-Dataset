module dvfs_controller (
    input wire [2:0] workload,
    output reg [1:0] frequency,
    output reg [1:0] voltage
);
    always @(workload) begin
        case (workload)
            3'b000: begin
                frequency = 2'b00;
                voltage = 2'b00;
            end
            3'b001, 3'b010: begin
                frequency = 2'b01;
                voltage = 2'b01;
            end
            3'b011, 3'b100: begin
                frequency = 2'b10;
                voltage = 2'b10;
            end
            3'b101, 3'b110, 3'b111: begin
                frequency = 2'b11;
                voltage = 2'b11;
            end
            default: begin
                frequency = 2'b00;
                voltage = 2'b00;
            end
        endcase
    end
endmodule