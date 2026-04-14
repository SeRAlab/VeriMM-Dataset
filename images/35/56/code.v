module fan_speed_control (
    input clk,
    input reset,
    input [2:0] speed_input,
    output reg [2:0] current_speed
);

always @(posedge clk or posedge reset) begin
    if (reset) begin
        current_speed <= 3'b000; // Default to Off
    end else if (speed_input != current_speed) begin
        current_speed <= speed_input;
    end
end

endmodule