module SLAM (
    input wire clk,
    input wire rst,
    input wire [7:0] sensor_position,
    input wire update_signal,
    output reg [7:0] estimated_position
);
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            estimated_position <= 8'd0;
        end else if (update_signal) begin
            estimated_position <= sensor_position; // Update the estimated position
        end
    end
endmodule