module fan_speed_controller (
    input wire clk,
    input wire reset,
    input wire [7:0] temperature,
    output reg [1:0] fan_speed // 00: OFF, 01: LOW, 10: HIGH
);

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            fan_speed <= 2'b00; // OFF
        end else begin
            if (temperature <= 20) begin
                fan_speed <= 2'b00; // OFF
            end else if (temperature > 20 && temperature <= 30) begin
                fan_speed <= 2'b01; // LOW
            end else begin
                fan_speed <= 2'b10; // HIGH
            end
        end
    end
endmodule