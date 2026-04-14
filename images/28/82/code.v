module dma_controller (
    input clk,
    input reset,
    input req1,      // Channel 1 request
    input req2,      // Channel 2 request
    output reg ack1, // Channel 1 acknowledge
    output reg ack2, // Channel 2 acknowledge
    output reg busy  // Busy signal
);

    reg [1:0] state; // 00: Idle, 01: Transfer Channel 1, 10: Transfer Channel 2

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= 2'b00; // Idle state
            ack1 <= 0;
            ack2 <= 0;
            busy <= 0;
        end else begin
            case (state)
                2'b00: begin // Idle
                    if (req1) begin
                        state <= 2'b01; // Go to Transfer Channel 1
                        busy <= 1;
                    end else if (req2) begin
                        state <= 2'b10; // Go to Transfer Channel 2
                        busy <= 1;
                    end
                end
                2'b01: begin // Transfer Channel 1
                    ack1 <= 1; // Acknowledge Channel 1
                    if (!req1) begin
                        ack1 <= 0; // No longer acknowledging Channel 1
                        busy <= 0;
                        state <= 2'b00; // Back to Idle
                    end
                end
                2'b10: begin // Transfer Channel 2
                    ack2 <= 1; // Acknowledge Channel 2
                    if (!req2) begin
                        ack2 <= 0; // No longer acknowledging Channel 2
                        busy <= 0;
                        state <= 2'b00; // Back to Idle
                    end
                end
            endcase
        end
    end
endmodule