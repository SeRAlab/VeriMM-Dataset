module dvfs_controller (
    input wire clk,
    input wire [1:0] performance_req,
    output reg [3:0] voltage,
    output reg [3:0] frequency
);

always @(posedge clk) begin
    case (performance_req)
        2'b00: begin
            voltage <= 4'b0001; // Low Voltage
            frequency <= 4'b0001; // Low Frequency
        end
        2'b01: begin
            voltage <= 4'b0010; // Medium Voltage
            frequency <= 4'b0010; // Medium Frequency
        end
        2'b10: begin
            voltage <= 4'b0100; // High Voltage
            frequency <= 4'b0100; // High Frequency
        end
        2'b11: begin
            voltage <= 4'b1000; // Maximum Voltage
            frequency <= 4'b1000; // Maximum Frequency
        end
        default: begin
            voltage <= 4'b0000; // Default to 0
            frequency <= 4'b0000; // Default to 0
        end
    endcase
end

endmodule