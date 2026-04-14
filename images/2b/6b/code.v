module SLAM_StateMachine(
    input clk,
    input rst_n,
    input start,
    input map,
    input stop,
    output reg [1:0] current_state
);

    // State encoding
    parameter IDLE = 2'b00;
    parameter NAVIGATING = 2'b01;
    parameter MAPPING = 2'b10;

    // State transition logic
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            current_state <= IDLE; // reset to IDLE
        end else begin
            case (current_state)
                IDLE: if (start) current_state <= NAVIGATING;
                NAVIGATING: if (map) current_state <= MAPPING;
                MAPPING: if (stop) current_state <= IDLE;
            endcase
        end
    end
endmodule