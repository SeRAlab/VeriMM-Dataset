module ARQ_System (
    input clk,
    input reset,
    input [4:0] data_in,
    input data_valid,
    output reg ack,
    output reg [4:0] sent_data,
    output reg retransmit
);
    reg [1:0] state; // 0 = idle, 1 = sending, 2 = waiting, 3 = retransmitting
    reg parity_bit;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= 0;
            ack <= 0;
            retransmit <= 0;
            sent_data <= 5'b00000;
        end else begin
            case (state)
                0: begin // idle
                    if (data_valid) begin
                        sent_data <= data_in;
                        parity_bit <= ^data_in; // calculate parity
                        state <= 1; // move to sending state
                        retransmit <= 0;
                    end
                end
                1: begin // sending
                    ack <= 1; // assume data is sent and wait for acknowledgment
                    state <= 2; // move to waiting state
                end
                2: begin // waiting
                    if (ack) begin
                        if (parity_bit == 1'b1) begin // error detected
                            retransmit <= 1;
                            state <= 3; // move to retransmitting state
                        end else begin
                            ack <= 0; // clear ack
                            state <= 0; // go back to idle
                        end
                    end
                end
                3: begin // retransmitting
                    sent_data <= data_in; // send again
                    ack <= 1; // assume data is sent again
                    state <= 2; // back to waiting
                end
                default: state <= 0; // default case
            endcase
        end
    end
endmodule