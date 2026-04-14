module fan_speed_control (
    input wire [1:0] speed_input,
    input wire clk,
    output reg [1:0] current_speed
);

always @(posedge clk) begin
    if (speed_input == 2'b00)
        current_speed <= 2'b00; // Off
    else
        current_speed <= speed_input; // Update to desired speed
end

endmodule