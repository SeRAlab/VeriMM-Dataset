module sliding_window_protocol (
    input clk,
    input rst,
    input send,
    input ack,
    output reg [3:0] sent_frames,
    output reg [3:0] acked_frames,
    output reg [3:0] window_size
);

    parameter MAX_WINDOW_SIZE = 4;
    parameter IDLE = 2'b00, SENDING = 2'b01, WAIT_ACK = 2'b10;
    
    reg [1:0] state, next_state;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= IDLE;
            sent_frames <= 0;
            acked_frames <= 0;
            window_size <= MAX_WINDOW_SIZE;
        end else begin
            state <= next_state;
        end
    end

    always @(*) begin
        next_state = state;
        case (state)
            IDLE: begin
                if (send && window_size > 0) begin
                    next_state = SENDING;
                end
            end
            SENDING: begin
                sent_frames = sent_frames + 1;
                window_size = window_size - 1;
                next_state = WAIT_ACK;
            end
            WAIT_ACK: begin
                if (ack) begin
                    acked_frames = acked_frames + 1;
                    window_size = window_size + 1;
                    next_state = IDLE;
                end
            end
        endcase
    end
endmodule