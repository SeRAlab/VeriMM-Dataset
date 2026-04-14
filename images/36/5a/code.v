module dvfs_controller (
    input clk,
    input [2:0] workload,
    output reg [1:0] voltage,
    output reg [1:0] frequency
);
    always @(posedge clk) begin
        case (workload)
            3'b000: begin
                voltage <= 2'b00; // 0.9V
                frequency <= 2'b00; // 500MHz
            end
            3'b001: begin
                voltage <= 2'b01; // 1.0V
                frequency <= 2'b01; // 1GHz
            end
            3'b010: begin
                voltage <= 2'b10; // 1.1V
                frequency <= 2'b10; // 1.5GHz
            end
            3'b011: begin
                voltage <= 2'b11; // 1.2V
                frequency <= 2'b11; // 2GHz
            end
            // additional cases can be handled as needed
            default: begin
                voltage <= 2'b00; // default to 0.9V
                frequency <= 2'b00; // default to 500MHz
            end
        endcase
    end
endmodule