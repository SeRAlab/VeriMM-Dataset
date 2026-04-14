module slam_system (
    input wire clk,
    input wire reset,
    input wire [7:0] sensor_reading,
    output reg [7:0] position
);

always @(posedge clk or posedge reset) begin
    if (reset) begin
        position <= 8'b00000000; // Reset position to 0
    end else begin
        position <= position + sensor_reading; // Update position based on sensor reading
    end
end

endmodule