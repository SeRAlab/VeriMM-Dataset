module stop_and_wait (
    input wire clk,
    input wire reset,
    input wire send_bit,
    input wire ack,
    output reg [7:0] sent_bit
);
    reg [2:0] state; // 0: Idle, 1: Sending, 2: Acknowledged

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= 0;
            sent_bit <= 8'b0;
        end else begin
            case (state)
                0: begin // Idle
                    if (send_bit) begin
                        sent_bit <= sent_bit + 1; // Increment bit to send
                        state <= 1; // Move to Sending
                    end
                end
                1: begin // Sending
                    if (ack) begin
                        state <= 2; // Move to Acknowledged
                    end
                end
                2: begin // Acknowledged
                    state <= 0; // Go back to Idle
                end
            endcase
        end
    end
endmodule