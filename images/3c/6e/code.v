module fan_speed_controller(
    input wire clk,
    input wire [1:0] desired_speed,
    output reg [1:0] fan_speed
);
    always @(posedge clk) begin
        fan_speed <= desired_speed;
    end
endmodule