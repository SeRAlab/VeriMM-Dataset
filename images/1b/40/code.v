module ARQ_System (
    input wire clk,
    input wire reset,
    input wire [7:0] data_in,
    input wire ack,
    input wire nack,
    output reg [7:0] data_out,
    output reg retransmit
);
    reg [7:0] sent_data;
    reg state; // 0: Sending, 1: Waiting for ACK

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= 0;
            retransmit <= 0;
            data_out <= 8'b0;
            sent_data <= 8'b0;
        end else begin
            case (state)
                0: begin // Sending state
                    sent_data <= data_in;
                    data_out <= sent_data;
                    retransmit <= 0;
                    state <= 1;
                end
                1: begin // Waiting for ACK
                    if (ack) begin
                        state <= 0; // Go back to sending
                        retransmit <= 0; // No retransmission needed
                    end else if (nack) begin
                        retransmit <= 1; // Need to retransmit
                        state <= 0; // Go back to sending state
                    end
                end
            endcase
        end
    end
endmodule