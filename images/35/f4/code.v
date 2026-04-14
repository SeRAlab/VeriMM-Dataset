module SLAM(
    input clk,
    input reset,
    input [3:0] sensor_data,  // 4-bit sensor input
    input control_signal,      // Direction control signal (0: left, 1: right)
    output reg [1:0] position  // 2-bit position output
);
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            position <= 2'b00;  // Reset position to 0
        end else begin
            if (control_signal) begin
                position <= position + (sensor_data[1:0]);  // Move right
            end else begin
                position <= position - (sensor_data[1:0]);  // Move left
            end
        end
    end
endmodule