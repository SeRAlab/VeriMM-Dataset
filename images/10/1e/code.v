module fan_speed_control(
    input wire clk,
    input wire reset,
    input wire [2:0] speed_control,
    output reg [2:0] current_speed
);
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            current_speed <= 3'b000; // Reset current speed to 0
        end else begin
            if (current_speed < speed_control) begin
                current_speed <= current_speed + 1; // Increase speed
            end else if (current_speed > speed_control) begin
                current_speed <= current_speed - 1; // Decrease speed
            end
        end
    end
endmodule