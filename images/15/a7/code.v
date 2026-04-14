module traffic_light_controller (
    input clk,
    input reset,
    output reg [1:0] state // 00 = RED, 01 = GREEN, 10 = YELLOW
);
    parameter RED = 2'b00, GREEN = 2'b01, YELLOW = 2'b10;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= RED; // Reset to RED state
        end else begin
            case (state)
                RED: state <= GREEN;
                GREEN: state <= YELLOW;
                YELLOW: state <= RED;
                default: state <= RED; // Fallback to RED
            endcase
        end
    end
endmodule