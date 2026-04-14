module stop_and_wait (
    input wire clk,
    input wire reset,
    input wire send_data,
    input wire recv_ack,
    output reg data_out,
    output reg ack_out
);

    reg [1:0] state; // 0: idle, 1: data sent, 2: ack received

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= 0;
            data_out <= 0;
            ack_out <= 0;
        end else begin
            case (state)
                0: begin // idle
                    if (send_data) begin
                        data_out <= 1;  // send data
                        state <= 1; // move to data sent state
                    end
                end
                1: begin // data sent
                    ack_out <= 0; // clear ack output
                    if (recv_ack) begin
                        ack_out <= 1; // acknowledge received
                        state <= 2; // move to ack received state
                    end
                end
                2: begin // ack received
                    data_out <= 0; // clear data output
                    if (!send_data) begin
                        state <= 0; // back to idle
                    end
                end
            endcase
        end
    end
endmodule