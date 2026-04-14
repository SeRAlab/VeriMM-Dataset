module fan_speed_controller(
    input wire clk,
    input wire [2:0] desired_speed,
    output reg [1:0] fan_speed
);

    always @(posedge clk) begin
        case (desired_speed)
            3'b000: fan_speed <= 2'b00; // OFF
            3'b001: fan_speed <= 2'b01; // LOW
            3'b010: fan_speed <= 2'b10; // MEDIUM
            3'b011: fan_speed <= 2'b11; // HIGH
            default: fan_speed <= fan_speed; // Invalid speed, retain last state
        endcase
    end
endmodule