module slam_state_machine (
    input clk,
    input reset,
    input start,
    input map,
    output reg [1:0] state // 00: IDLE, 01: MOVE, 10: MAP
);

    // State encoding
    parameter IDLE = 2'b00, MOVE = 2'b01, MAP = 2'b10;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE;
        end else begin
            case (state)
                IDLE: if (start) state <= MOVE;
                MOVE: if (map) state <= MAP;
                MAP: state <= IDLE; // return to IDLE after mapping
                default: state <= IDLE;
            endcase
        end
    end
endmodule