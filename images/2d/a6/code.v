module sliding_window_protocol (
    input clk,
    input rst,
    input send,
    input ack,
    output reg [3:0] window_size,
    output reg [3:0] sent_packets,
    output reg [3:0] acked_packets,
    output reg [3:0] state // 0: idle, 1: sending, 2: waiting for ack
);

    parameter MAX_WINDOW_SIZE = 4;
    parameter IDLE = 0, SENDING = 1, WAITING_ACK = 2;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= IDLE;
            window_size <= 0;
            sent_packets <= 0;
            acked_packets <= 0;
        end else begin
            case (state)
                IDLE: begin
                    if (send && window_size < MAX_WINDOW_SIZE) begin
                        sent_packets <= sent_packets + 1;
                        window_size <= window_size + 1;
                        state <= SENDING;
                    end
                end
                SENDING: begin
                    if (ack) begin
                        acked_packets <= acked_packets + 1;
                        window_size <= window_size - 1;
                        state <= WAITING_ACK;
                    end
                end
                WAITING_ACK: begin
                    if (!ack) begin
                        state <= IDLE;
                    end
                end
            endcase
        end
    end
endmodule