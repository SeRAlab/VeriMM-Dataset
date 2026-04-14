module sliding_window_protocol (
    input clk,
    input reset,
    input send_packet,
    input ack_received,
    output reg [3:0] window_size,
    output reg [3:0] packets_sent,
    output reg [3:0] packets_acknowledged,
    output reg busy
);
    parameter MAX_WINDOW_SIZE = 4;
    parameter IDLE = 2'b00, SENDING = 2'b01, WAITING_ACK = 2'b10;
    reg [1:0] state, next_state;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE;
            packets_sent <= 0;
            packets_acknowledged <= 0;
            window_size <= MAX_WINDOW_SIZE;
            busy <= 0;
        end else begin
            state <= next_state;
        end
    end

    always @(*) begin
        next_state = state;
        case (state)
            IDLE: begin
                if (send_packet && window_size > 0) begin
                    packets_sent = packets_sent + 1;
                    window_size = window_size - 1;
                    busy = 1;
                    next_state = SENDING;
                end
            end
            SENDING: begin
                if (ack_received) begin
                    packets_acknowledged = packets_acknowledged + 1;
                    window_size = window_size + 1;
                    next_state = WAITING_ACK;
                end
            end
            WAITING_ACK: begin
                if (send_packet && window_size > 0) begin
                    packets_sent = packets_sent + 1;
                    window_size = window_size - 1;
                    busy = 1;
                    next_state = SENDING;
                end else if (!send_packet) begin
                    busy = 0;
                    next_state = IDLE;
                end
            end
        endcase
    end
endmodule