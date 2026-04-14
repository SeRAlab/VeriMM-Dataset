module ethernet_mac_controller(
    input clk,
    input reset,
    input start,
    input receive,
    input forward,
    output reg [1:0] current_state
);
    // State encoding
    parameter IDLE = 2'b00, LISTENING = 2'b01, LEARNING = 2'b10, FORWARDING = 2'b11;
    reg [1:0] next_state;

    // State transition logic
    always @(*) begin
        case (current_state)
            IDLE: begin
                if (start) next_state = LISTENING;
                else next_state = IDLE;
            end
            LISTENING: begin
                if (receive) next_state = LEARNING;
                else next_state = LISTENING;
            end
            LEARNING: begin
                if (forward) next_state = FORWARDING;
                else next_state = LEARNING;
            end
            FORWARDING: begin
                next_state = IDLE; // transition back to IDLE for demo purposes
            end
            default: next_state = IDLE;
        endcase
    end

    // State update logic
    always @(posedge clk or posedge reset) begin
        if (reset)
            current_state <= IDLE;
        else
            current_state <= next_state;
    end
endmodule