module ARQ (
    input wire clk,
    input wire rst,
    input wire data_in,
    input wire ack,
    output reg data_out
);
    reg [1:0] state; // 0: Idle, 1: Send, 2: Wait for ACK

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= 0;
            data_out <= 0;
        end else begin
            case (state)
                0: begin // Idle
                    if (data_in) begin
                        data_out <= data_in;
                        state <= 1; // Move to Send state
                    end
                end
                1: begin // Send
                    if (ack) begin
                        state <= 0; // Return to Idle
                    end else begin
                        state <= 2; // Move to Wait for ACK state
                    end
                end
                2: begin // Wait for ACK
                    if (ack) begin
                        state <= 0; // Return to Idle
                    end else begin
                        data_out <= data_out; // Retransmit
                    end
                end
            endcase
        end
    end
endmodule