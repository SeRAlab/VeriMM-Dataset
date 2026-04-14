module sliding_window_protocol(
    input clk,
    input reset,
    input send,
    input ack,
    output reg [3:0] data_out,
    output reg ready
);
    reg [1:0] sender_state;
    reg [1:0] receiver_state;
    reg [1:0] window_base; // base of the window
    reg [1:0] next_packet; // next packet to be sent

    localparam IDLE = 2'b00,
               SENDING = 2'b01,
               WAITING_ACK = 2'b10;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            sender_state <= IDLE;
            window_base <= 0;
            next_packet <= 0;
            ready <= 1;
            data_out <= 4'b0000;
        end else begin
            case (sender_state)
                IDLE: begin
                    if (send && ready) begin
                        data_out <= next_packet; // send the next packet
                        sender_state <= SENDING;
                        ready <= 0; // not ready until ack is received
                    end
                end
                SENDING: begin
                    sender_state <= WAITING_ACK; // wait for ack
                end
                WAITING_ACK: begin
                    if (ack) begin
                        window_base <= window_base + 1; // move window
                        next_packet <= next_packet + 1; // increment packet to send
                        ready <= 1; // ready to send next packet
                        sender_state <= IDLE; // go back to idle
                    end
                end
            endcase
        end
    end
endmodule