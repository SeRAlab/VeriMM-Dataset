module ARQ_System(
    input wire clk,
    input wire reset,
    input wire [7:0] data_in,
    input wire ack,
    output reg [7:0] sent_data,
    output reg retransmit
);
    reg [1:0] state; // 0: Idle, 1: Sending, 2: Waiting for ACK
    parameter IDLE = 2'b00, SENDING = 2'b01, WAITING = 2'b10;
    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE;
            sent_data <= 8'b0;
            retransmit <= 1'b0;
        end else begin
            case (state)
                IDLE: begin
                    sent_data <= data_in;
                    retransmit <= 1'b0;
                    state <= SENDING;
                end
                SENDING: begin
                    if (ack) begin
                        state <= IDLE; // Acknowledged, go back to idle
                    end else begin
                        retransmit <= 1'b1; // Need to retransmit
                        state <= WAITING; // Wait for the next clock to send again
                    end
                end
                WAITING: begin
                    retransmit <= 1'b0; // Reset retransmit signal
                    state <= SENDING; // Try sending the packet again
                end
            endcase
        end
    end
endmodule