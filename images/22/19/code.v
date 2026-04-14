module slam_system (
    input clk,
    input reset,
    input sensor_input,
    output reg [1:0] position
);
    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            position <= 2'b00; // Initial position
        end else begin
            if (sensor_input) begin
                position <= (position + 1) % 4; // Increment position
            end
        end
    end
endmodule