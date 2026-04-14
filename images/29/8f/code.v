module fan_speed_controller(
    input clk,
    input [2:0] temperature,
    output reg [1:0] fan_speed
);

    always @(posedge clk) begin
        case (temperature)
            3'b000, 3'b001, 3'b010: fan_speed <= 2'b00; // Low speed
            3'b011, 3'b100, 3'b101: fan_speed <= 2'b01; // Medium speed
            3'b110, 3'b111: fan_speed <= 2'b10; // High speed
            default: fan_speed <= 2'b11; // Off
        endcase
    end
endmodule