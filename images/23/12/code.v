module wifi_state_machine(
    input clk,
    input reset,
    input start_connect,
    input connection_done,
    output reg [1:0] state
);
    // State encoding
    localparam IDLE = 2'b00, CONNECTING = 2'b01, CONNECTED = 2'b10;

    // State register
    reg [1:0] current_state, next_state;

    // Sequential logic - state transition
    always @(posedge clk or posedge reset) begin
        if (reset)
            current_state <= IDLE;
        else
            current_state <= next_state;
    end

    // Combinational logic - next state logic
    always @(*) begin
        case (current_state)
            IDLE: begin
                if (start_connect)
                    next_state = CONNECTING;
                else
                    next_state = IDLE;
            end
            CONNECTING: begin
                if (connection_done)
                    next_state = CONNECTED;
                else
                    next_state = CONNECTING;
            end
            CONNECTED: begin
                next_state = IDLE; // This example resets automatically
            end
            default: next_state = IDLE;
        endcase
    end

    // Output logic
    always @(posedge clk) begin
        state <= current_state;
    end
endmodule