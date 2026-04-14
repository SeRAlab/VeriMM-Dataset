module slam_system (
    input clk,
    input reset,
    input [1:0] position_update,
    input [4:0] map_update,
    output reg [1:0] current_position,
    output reg [31:0] map
);

always @(posedge clk or posedge reset) begin
    if (reset) begin
        current_position <= 2'b00; // Reset position
        map <= 32'b0; // Reset map
    end else begin
        // Update current_position based on position_update
        case (position_update)
            2'b00: current_position <= current_position; // No movement
            2'b01: current_position <= current_position - 1; // Move left
            2'b10: current_position <= current_position + 1; // Move right
            2'b11: current_position <= current_position; // Move forward
        endcase

        // Update map based on map_update
        map[current_position] <= 1'b1; // Mark the current position in the map
    end
end

endmodule