module SLAM_StateMachine (
    input clk,
    input reset,
    input move_cmd,
    input map_cmd,
    output reg [1:0] state // 00: IDLE, 01: MOVING, 10: MAPPING
);

    // Define state encoding
    parameter IDLE = 2'b00;
    parameter MOVING = 2'b01;
    parameter MAPPING = 2'b10;

    // State transition
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE;
        end else begin
            case (state)
                IDLE: begin
                    if (move_cmd) state <= MOVING;
                    else if (map_cmd) state <= MAPPING;
                end
                MOVING: begin
                    if (!move_cmd) state <= IDLE;
                end
                MAPPING: begin
                    if (!map_cmd) state <= IDLE;
                end
                default: state <= IDLE;
            endcase
        end
    end
endmodule