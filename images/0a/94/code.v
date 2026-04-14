module SLAM_FSM (
    input clk,
    input reset,
    input start,
    input map_done,
    output reg [1:0] current_state
);
    // State encoding
    parameter IDLE = 2'b00, MAPPING = 2'b01, LOCALIZING = 2'b10;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            current_state <= IDLE;
        end else begin
            case (current_state)
                IDLE: begin
                    if (start) current_state <= MAPPING;
                end
                MAPPING: begin
                    if (map_done) current_state <= LOCALIZING;
                end
                LOCALIZING: begin
                    current_state <= IDLE; // Assume it goes back to IDLE after LOCALIZING
                end
                default: current_state <= IDLE; // Safety default
            endcase
        end
    end
endmodule