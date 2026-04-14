module fan_speed_control(
    input clk,
    input reset,
    input [7:0] temperature,
    output reg [1:0] fan_speed // 00 - low, 01 - medium, 10 - high
);
    reg [1:0] next_state;
    reg [3:0] debounce_counter;
    reg debounce_state;

    // Debounce logic
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            debounce_counter <= 0;
            debounce_state <= 0;
        end else begin
            if (temperature != debounce_state) begin
                debounce_counter <= debounce_counter + 1;
                if (debounce_counter == 4'd15) begin
                    debounce_state <= temperature;
                    debounce_counter <= 0;
                end
            end else begin
                debounce_counter <= 0;
            end
        end
    end

    // State machine for fan speed control
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            fan_speed <= 2'b00; // Low speed
        end else begin
            case (debounce_state)
                8'd0: fan_speed <= 2'b00; // Low speed
                8'd1: fan_speed <= 2'b00; // Low speed
                default: begin
                    if (temperature < 8'd20) begin
                        fan_speed <= 2'b00; // Low speed
                    end else if (temperature < 8'd30) begin
                        fan_speed <= 2'b01; // Medium speed
                    end else begin
                        fan_speed <= 2'b10; // High speed
                    end
                end
            endcase
        end
    end
endmodule