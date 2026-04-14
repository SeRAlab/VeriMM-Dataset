module SLAM(
    input wire clk,
    input wire reset,
    input wire [7:0] sensor_data,
    input wire update_map,
    output reg [15:0] estimated_position,
    output reg map_updated
);
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            estimated_position <= 16'b0;
            map_updated <= 1'b0;
        end else begin
            if (update_map) begin
                estimated_position <= estimated_position + sensor_data; // Update position based on sensor data
                map_updated <= 1'b1; // Indicate that the map has been updated
            end else begin
                map_updated <= 1'b0; // No update to the map
            end
        end
    end
endmodule