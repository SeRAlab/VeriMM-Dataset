module traffic_light_controller (
    input clk,
    input reset,
    output reg [1:0] state // 00: RED, 01: GREEN, 10: YELLOW
);
    // State encoding
    parameter RED = 2'b00, GREEN = 2'b01, YELLOW = 2'b10;
    reg [3:0] counter; // Counter for timing

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= RED;
            counter <= 0;
        end else begin
            counter <= counter + 1;
            case (state)
                RED: begin
                    if (counter == 4'd9) begin // RED for 10 clock cycles
                        state <= GREEN;
                        counter <= 0;
                    end
                end
                GREEN: begin
                    if (counter == 4'd4) begin // GREEN for 5 clock cycles
                        state <= YELLOW;
                        counter <= 0;
                    end
                end
                YELLOW: begin
                    if (counter == 4'd2) begin // YELLOW for 3 clock cycles
                        state <= RED;
                        counter <= 0;
                    end
                end
            endcase
        end
    end
endmodule