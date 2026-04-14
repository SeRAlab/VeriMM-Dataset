module robot_slam (
    input clk,
    input rst,
    input start,
    input scan,
    input return,
    output reg [1:0] state // 00: IDLE, 01: MOVE, 10: SCAN, 11: RETURN
);

    parameter IDLE = 2'b00,
              MOVE = 2'b01,
              SCAN = 2'b10,
              RETURN = 2'b11;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= IDLE;
        end else begin
            case (state)
                IDLE: if (start) state <= MOVE;
                MOVE: if (scan) state <= SCAN;
                SCAN: if (return) state <= RETURN;
                RETURN: state <= IDLE; // return to IDLE after returning
                default: state <= IDLE;
            endcase
        end
    end
endmodule