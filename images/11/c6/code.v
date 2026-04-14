module traffic_light_controller (
    input clk,
    input reset,
    output reg [1:0] state // 00: RED, 01: GREEN, 10: YELLOW
);

    // State encoding
    localparam RED = 2'b00;
    localparam GREEN = 2'b01;
    localparam YELLOW = 2'b10;

    // State transition
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= RED;
        end else begin
            case (state)
                RED: state <= GREEN;
                GREEN: state <= YELLOW;
                YELLOW: state <= RED;
                default: state <= RED; // Default to RED state
            endcase
        end
    end
endmodule