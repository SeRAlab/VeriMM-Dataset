module slam_fsm (
    input wire clk,
    input wire reset,
    input wire go,
    input wire done,
    output reg [1:0] state // 00: IDLE, 01: MOVE, 10: MAP
);

    parameter IDLE = 2'b00, MOVE = 2'b01, MAP = 2'b10;
    reg [1:0] next_state;
    reg [4:0] count; // Counter for MOVE state

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE;
            count <= 0;
        end else begin
            state <= next_state;
            if (state == MOVE) begin
                count <= count + 1;
            end else begin
                count <= 0;
            end
        end
    end

    always @(*) begin
        case (state)
            IDLE: begin
                if (go) next_state = MOVE;
                else next_state = IDLE;
            end
            MOVE: begin
                if (count == 5'd10) // Move for 10 clock cycles
                    next_state = MAP;
                else
                    next_state = MOVE;
            end
            MAP: begin
                if (done) next_state = IDLE;
                else next_state = MAP;
            end
            default: next_state = IDLE;
        endcase
    end
endmodule