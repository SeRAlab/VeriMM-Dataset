module arq_system (
    input clk,
    input reset,
    input [4:0] data_in,
    input ack_nack, // 1 for ACK, 0 for NACK
    output reg [4:0] data_out,
    output reg [1:0] state // 00: idle, 01: sending, 10: received ACK, 11: received NACK
);

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= 2'b00;
            data_out <= 5'b00000;
        end else begin
            case (state)
                2'b00: begin // idle state
                    state <= 2'b01; // move to sending state
                    data_out <= data_in; // prepare data for sending
                end
                2'b01: begin // sending state
                    if (ack_nack) begin // received ACK
                        state <= 2'b10; // move to received ACK state
                    end else begin // received NACK
                        state <= 2'b11; // move to received NACK state
                        data_out <= data_in; // resend data
                    end
                end
                2'b10: begin // received ACK state
                    state <= 2'b00; // go back to idle
                end
                2'b11: begin // received NACK state
                    state <= 2'b01; // resend data
                end
            endcase
        end
    end
endmodule