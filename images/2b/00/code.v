module stop_and_wait(
    input clk,
    input reset,
    input send_data,
    input ack_received,
    output reg [3:0] data_out,
    output reg send_packet,
    output reg retransmit
);
    reg [1:0] state;
    parameter IDLE = 2'b00, SENDING = 2'b01, WAITING = 2'b10, RETRANSMIT = 2'b11;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE;
            send_packet <= 0;
            retransmit <= 0;
            data_out <= 4'b0000;
        end else begin
            case (state)
                IDLE: begin
                    if (send_data) begin
                        data_out <= data_out + 1; // Incrementing data for simplicity
                        send_packet <= 1;
                        state <= SENDING;
                    end
                end
                SENDING: begin
                    send_packet <= 0;
                    state <= WAITING;
                end
                WAITING: begin
                    if (ack_received) begin
                        state <= IDLE;
                        retransmit <= 0; // received ack, no retransmit needed
                    end else begin
                        retransmit <= 1; // timeout, need to retransmit
                        state <= RETRANSMIT;
                    end
                end
                RETRANSMIT: begin
                    send_packet <= 1;
                    state <= SENDING;
                end
            endcase
        end
    end
endmodule