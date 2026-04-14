module slam_fsm(
    input clk,
    input reset,
    input start,
    input map_done,
    output reg [1:0] state
);
    parameter IDLE = 2'b00, MAP = 2'b01, LOCALIZE = 2'b10;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE;
        end else begin
            case (state)
                IDLE: if (start) state <= MAP;
                MAP: if (map_done) state <= LOCALIZE;
                LOCALIZE: if (reset) state <= IDLE;
                default: state <= IDLE;
            endcase
        end
    end
endmodule