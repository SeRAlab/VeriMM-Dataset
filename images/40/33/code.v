module dma_controller (
    input clk,
    input reset,
    input req1,
    input req2,
    output reg busy,
    output reg ack1,
    output reg ack2
);

    reg state;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            busy <= 0;
            ack1 <= 0;
            ack2 <= 0;
            state <= 0;
        end else begin
            case (state)
                0: begin // Idle state
                    if (req1) begin
                        busy <= 1;
                        ack1 <= 1;
                        ack2 <= 0;
                        state <= 1;
                    end else if (req2) begin
                        busy <= 1;
                        ack1 <= 0;
                        ack2 <= 1;
                        state <= 2;
                    end
                end
                1: begin // Processing req1
                    if (ack1) begin
                        ack1 <= 0; // Acknowledge req1
                        busy <= 0; // Go back to idle
                        state <= 0;
                    end
                end
                2: begin // Processing req2
                    if (ack2) begin
                        ack2 <= 0; // Acknowledge req2
                        busy <= 0; // Go back to idle
                        state <= 0;
                    end
                end
            endcase
        end
    end
endmodule