module slam_fsm (
    input clk,
    input rst,
    input start,
    input complete,
    output reg [1:0] current_state
);

    // State Encoding
    parameter IDLE = 2'b00, LOCALIZING = 2'b01, MAPPING = 2'b10;
    
    // State Variable
    reg [1:0] state, next_state;

    // State Transition
    always @(posedge clk or posedge rst) begin
        if (rst)
            state <= IDLE; // Reset to IDLE state
        else
            state <= next_state;
    end

    // Next State Logic
    always @(*) begin
        case (state)
            IDLE: begin
                if (start)
                    next_state = LOCALIZING;
                else
                    next_state = IDLE;
            end
            LOCALIZING: begin
                if (complete)
                    next_state = MAPPING;
                else
                    next_state = LOCALIZING;
            end
            MAPPING: begin
                next_state = IDLE; // Go back to IDLE after mapping
            end
            default: next_state = IDLE;
        endcase
    end

    // Current State Output
    always @(posedge clk or posedge rst) begin
        if (rst)
            current_state <= IDLE;
        else
            current_state <= state;
    end

endmodule