module SLAM_StateMachine(
    input clk,
    input reset,
    input start,
    input complete,
    input found,
    input done,
    output reg [1:0] current_state
);
    // State encoding
    localparam IDLE = 2'b00, MAPPING = 2'b01, LOCALIZING = 2'b10, UPDATING = 2'b11;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            current_state <= IDLE;
        end else begin
            case (current_state)
                IDLE: if (start) current_state <= MAPPING;
                MAPPING: if (complete) current_state <= LOCALIZING;
                LOCALIZING: if (found) current_state <= UPDATING;
                UPDATING: if (done) current_state <= IDLE;
                default: current_state <= IDLE;
            endcase
        end
    end
endmodule