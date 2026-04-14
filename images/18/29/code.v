module dvfs_controller (
    input wire clk,
    input wire [1:0] workload,
    output reg [2:0] frequency,
    output reg [1:0] voltage
);
    always @(posedge clk) begin
        case (workload)
            2'b00: begin
                frequency <= 3'b000; // Low frequency
                voltage <= 2'b00;    // Low voltage
            end
            2'b01: begin
                frequency <= 3'b001; // Medium frequency
                voltage <= 2'b01;    // Medium voltage
            end
            2'b10: begin
                frequency <= 3'b010; // High frequency
                voltage <= 2'b10;    // High voltage
            end
            2'b11: begin
                frequency <= 3'b011; // Max frequency
                voltage <= 2'b11;    // Max voltage
            end
            default: begin
                frequency <= 3'b000; // Default to low
                voltage <= 2'b00;    // Default to low
            end
        endcase
    end
endmodule