module slam_state_machine (
    input clk,
    input rst,
    input [1:0] sensor_data, // 2-bit input for obstacle detection
    output reg [2:0] position // 3-bit output for position
);

always @(posedge clk or posedge rst) begin
    if (rst) begin
        position <= 3'b000; // Reset position to 0
    end else begin
        if (sensor_data == 2'b00) begin
            position <= position + 1; // Increment position if no obstacles
        end
        // If obstacles are detected (sensor_data != 2'b00), do nothing
    end
end

endmodule