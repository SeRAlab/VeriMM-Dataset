module fan_speed_control(
    input clk,
    input [3:0] temp,
    output reg [1:0] fan_speed
);
    always @(posedge clk) begin
        if (temp < 4'd10)
            fan_speed <= 2'b00; // Low speed
        else if (temp >= 4'd10 && temp <= 4'd20)
            fan_speed <= 2'b01; // Medium speed
        else
            fan_speed <= 2'b10; // High speed
    end
endmodule