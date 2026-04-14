module stop_and_wait (
    input wire clk,
    input wire reset,
    input wire send,
    input wire ack,
    output reg frame_sent,
    output reg state // 0: waiting for ACK, 1: sending frame
);

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            frame_sent <= 0;
            state <= 0; // Start in waiting state
        end else begin
            case (state)
                0: begin // Waiting for ACK
                    frame_sent <= 0;
                    if (send) begin
                        frame_sent <= 1; // Send frame
                        state <= 1; // Move to sending state
                    end
                end
                1: begin // Sending frame
                    if (ack) begin
                        state <= 0; // Return to waiting state upon ACK
                    end
                end
                default: state <= 0; // Reset to waiting state
            endcase
        end
    end
endmodule