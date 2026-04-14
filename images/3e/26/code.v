module stop_and_wait(
    input clk,
    input reset,
    input send_request, // Trigger to send a frame
    input ack,          // Acknowledgment signal from receiver
    output reg send,    // Signal to send data
    output reg [7:0] data_out, // Data to be sent
    output reg frame_sent // Indicates a frame has been sent
);
    reg [2:0] state; // State variable

    parameter IDLE = 3'b000,
              SEND_FRAME = 3'b001,
              WAIT_ACK = 3'b010,
              FRAME_SENT = 3'b011;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE;
            send <= 0;
            data_out <= 8'b0;
            frame_sent <= 0;
        end else begin
            case (state)
                IDLE: begin
                    if (send_request) begin
                        data_out <= data_out + 1; // Increment data to send
                        state <= SEND_FRAME;
                    end
                end
                SEND_FRAME: begin
                    send <= 1;
                    frame_sent <= 0;
                    state <= WAIT_ACK;
                end
                WAIT_ACK: begin
                    if (ack) begin
                        send <= 0;
                        frame_sent <= 1; // Acknowledgment received
                        state <= FRAME_SENT;
                    end
                end
                FRAME_SENT: begin
                    state <= IDLE; // Return to IDLE after frame is sent
                end
            endcase
        end
    end
endmodule