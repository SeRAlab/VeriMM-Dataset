module sliding_window_protocol (
    input clk,
    input rst,
    input ack,
    output reg [3:0] sent_packets,
    output reg retransmit,
    output reg [1:0] state
);
    parameter IDLE = 2'b00, SENDING = 2'b01, WAIT_ACK = 2'b10, RETRANSMIT = 2'b11;
    reg [1:0] next_state;
    reg [1:0] packet_count;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= IDLE;
            sent_packets <= 0;
            retransmit <= 0;
            packet_count <= 0;
        end else begin
            state <= next_state;
            if (state == SENDING) begin
                sent_packets <= sent_packets + 1;
                packet_count <= packet_count + 1;
            end
            if (state == RETRANSMIT) begin
                retransmit <= 1;
            end else begin
                retransmit <= 0;
            end
        end
    end

    always @(*) begin
        case (state)
            IDLE: begin
                if (packet_count < 4) begin
                    next_state = SENDING;
                end else begin
                    next_state = IDLE;
                end
            end
            SENDING: begin
                if (ack) begin
                    next_state = WAIT_ACK;
                end else begin
                    next_state = RETRANSMIT;
                end
            end
            WAIT_ACK: begin
                if (packet_count < 4) begin
                    next_state = SENDING;
                end else begin
                    next_state = IDLE;
                end
            end
            RETRANSMIT: begin
                next_state = SENDING;
            end
            default: next_state = IDLE;
        endcase
    end
endmodule