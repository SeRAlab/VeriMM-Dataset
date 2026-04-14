module fan_speed_control (
    input clk,
    input reset,
    input [7:0] temperature,  // Temperature input in degrees Celsius
    output reg [1:0] fan_speed // 00: OFF, 01: LOW, 10: MEDIUM, 11: HIGH
);

    // State encoding
    localparam OFF = 2'b00;
    localparam LOW = 2'b01;
    localparam MEDIUM = 2'b10;
    localparam HIGH = 2'b11;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            fan_speed <= OFF;
        end else begin
            case (temperature)
                8'd0: fan_speed <= OFF;
                8'd1: fan_speed <= OFF;
                // ... other values for OFF
                8'd20: fan_speed <= LOW; // Transition below 20
                8'd30: fan_speed <= MEDIUM; // Transition to MEDIUM
                8'd40: fan_speed <= HIGH; // Transition to HIGH
                default: begin
                    if (temperature < 20) fan_speed <= OFF;
                    else if (temperature < 30) fan_speed <= LOW;
                    else if (temperature < 40) fan_speed <= MEDIUM;
                    else fan_speed <= HIGH;
                end
            endcase
        end
    end
endmodule