module fan_speed_controller(
    input wire clk,
    input wire reset,
    input wire [2:0] temperature,
    output reg [1:0] fan_speed
);
    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            fan_speed <= 2'b00; // OFF
        end else begin
            case (temperature)
                3'b000, 3'b001, 3'b010: fan_speed <= 2'b00; // OFF
                3'b011, 3'b100: fan_speed <= 2'b01; // LOW
                3'b101: fan_speed <= 2'b10; // MEDIUM
                3'b110, 3'b111: fan_speed <= 2'b11; // HIGH
                default: fan_speed <= 2'b00; // default to OFF
            endcase
        end
    end
endmodule