module elevator_controller (
    input clk,
    input reset,
    input req_up,
    input req_down,
    output reg [1:0] state // 00: Idle, 01: Moving Up, 10: Moving Down
);
    // State encoding
    parameter IDLE = 2'b00, MOVING_UP = 2'b01, MOVING_DOWN = 2'b10;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE;
        end else begin
            case (state)
                IDLE: begin
                    if (req_up)
                        state <= MOVING_UP;
                    else if (req_down)
                        state <= MOVING_DOWN;
                end
                MOVING_UP: begin
                    if (!req_up)
                        state <= IDLE;
                end
                MOVING_DOWN: begin
                    if (!req_down)
                        state <= IDLE;
                end
                default: state <= IDLE;
            endcase
        end
    end
endmodule