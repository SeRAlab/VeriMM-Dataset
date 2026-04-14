module stop_and_wait_arq(
    input clk,
    input rst,
    input send_data,
    input ack,
    input nack,
    output reg data_out,
    output reg retransmit
);
    reg [1:0] state; // 0: idle, 1: sending, 2: waiting, 3: retransmitting

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= 0;
            data_out <= 0;
            retransmit <= 0;
        end else begin
            case (state)
                0: begin // idle
                    if (send_data) begin
                        data_out <= 1; // send data
                        state <= 1;
                    end
                end
                1: begin // sending
                    state <= 2; // move to waiting for ACK
                end
                2: begin // waiting
                    if (ack) begin
                        data_out <= 0; // acknowledge received
                        state <= 0; // back to idle
                    end else if (nack) begin
                        state <= 3; // move to retransmitting
                    end
                end
                3: begin // retransmitting
                    data_out <= 1; // retransmit data
                    state <= 2; // move back to waiting for ACK
                end
            endcase
        end
    end
endmodule