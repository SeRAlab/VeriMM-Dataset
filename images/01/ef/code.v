module fan_speed_control(
    input wire clk,
    input wire rst,
    input wire [7:0] temperature,
    output reg [1:0] fan_speed
);

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            fan_speed <= 2'b00; // State 0: Fan off
        end else begin
            case (temperature)
                8'd0  : fan_speed <= 2'b00; // State 0
                8'd20 : fan_speed <= 2'b01; // State 1
                8'd30 : fan_speed <= 2'b10; // State 2
                8'd40 : fan_speed <= 2'b11; // State 3
                default: begin
                    if (temperature < 20) begin
                        fan_speed <= 2'b00; // Off
                    end else if (temperature < 30) begin
                        fan_speed <= 2'b01; // Low
                    end else if (temperature < 40) begin
                        fan_speed <= 2'b10; // Medium
                    end else begin
                        fan_speed <= 2'b11; // High
                    end
                end
            endcase
        end
    end
endmodule