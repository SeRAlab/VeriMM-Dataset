module stop_and_wait (
    input wire clk,
    input wire reset,
    input wire send_frame,
    input wire ack,
    output reg busy,
    output reg frame_sent
);

    reg [1:0] state, next_state;

    // State Encoding
    localparam IDLE = 2'b00,
               SENT = 2'b01,
               WAIT_ACK = 2'b10;

    // Sequential logic for state transition
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE;
        end else begin
            state <= next_state;
        end
    end

    // Combinational logic for next state and outputs
    always @(*) begin
        next_state = state; // Default to stay in current state
        busy = 0; // Default busy to 0
        frame_sent = 0; // Default frame_sent to 0

        case (state)
            IDLE: begin
                if (send_frame) begin
                    next_state = SENT;
                    busy = 1;
                    frame_sent = 1;
                end
            end
            SENT: begin
                next_state = WAIT_ACK;
            end
            WAIT_ACK: begin
                if (ack) begin
                    next_state = IDLE;
                    busy = 0;
                end
            end
        endcase
    end
endmodule