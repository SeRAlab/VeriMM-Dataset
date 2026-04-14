module slam_system (
    input clk,
    input rst,
    input [7:0] left_sensor,
    input [7:0] right_sensor,
    input [7:0] front_sensor,
    output reg [7:0] current_position, // Represents the position in a 1D space
    output reg [7:0] map_left, // Stores distance mapping for left
    output reg [7:0] map_right, // Stores distance mapping for right
    output reg [7:0] map_front // Stores distance mapping for front
);
    
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            current_position <= 8'b0;
            map_left <= 8'b0;
            map_right <= 8'b0;
            map_front <= 8'b0;
        end else begin
            // Update position based on front sensor
            current_position <= current_position + front_sensor;
            // Update maps with sensor readings
            map_left <= left_sensor;
            map_right <= right_sensor;
            map_front <= front_sensor;
        end
    end
endmodule