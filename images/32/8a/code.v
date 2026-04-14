module stop_and_wait (
    input clk,
    input rst,
    input send_bit,
    input ack,
    output reg send_signal,
    output reg ack_signal
);
    reg [1:0] state; // 0: waiting, 1: sending, 2: acked

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= 0;
            send_signal <= 0;
            ack_signal <= 0;
        end else begin
            case (state)
                0: begin // waiting for send
                    if (send_bit) begin
                        send_signal <= 1; // start sending
                        state <= 1;
                    end
                end
                1: begin // sending
                    if (ack) begin
                        ack_signal <= 1; // acknowledge received
                        state <= 2;
                    end else begin
                        send_signal <= 1; // resend
                    end
                end
                2: begin // acked
                    send_signal <= 0; // stop sending
                    ack_signal <= 0; // reset ACK
                    state <= 0; // go back to waiting
                end
            endcase
        end
    end
endmodule