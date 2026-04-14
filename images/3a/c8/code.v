module sliding_window_protocol(
    input clk,
    input rst,
    input send_enable,
    input ack,
    input timeout,
    output reg [3:0] window_size,
    output reg [3:0] sent_frames,
    output reg [3:0] acked_frames,
    output reg busy
);
    parameter MAX_WINDOW_SIZE = 4'b0100; // Window size of 4
    parameter IDLE = 2'b00, SENDING = 2'b01, WAIT_ACK = 2'b10;
    reg [1:0] state, next_state;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= IDLE;
            window_size <= 4'b0000;
            sent_frames <= 4'b0000;
            acked_frames <= 4'b0000;
            busy <= 0;
        end else begin
            state <= next_state;
            if (state == SENDING && send_enable && window_size < MAX_WINDOW_SIZE) begin
                sent_frames <= sent_frames + 1;
                window_size <= window_size + 1;
                busy <= 1;
            end
            if (ack) begin
                acked_frames <= acked_frames + 1;
                window_size <= window_size - 1;
            end
            if (timeout) begin
                window_size <= 4'b0000; // Reset window size on timeout
                busy <= 0;
            end
        end
    end

    always @(*) begin
        case (state)
            IDLE: next_state = send_enable ? SENDING : IDLE;
            SENDING: next_state = (window_size < MAX_WINDOW_SIZE) ? SENDING : WAIT_ACK;
            WAIT_ACK: next_state = ack ? IDLE : WAIT_ACK;
            default: next_state = IDLE;
        endcase
    end
endmodule