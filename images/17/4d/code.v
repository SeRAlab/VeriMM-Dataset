module stop_and_wait (
    input clk,
    input reset,
    input send_data,
    input ack,
    output reg data_out,
    output reg state // 0 = waiting, 1 = sending
);
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= 0;
            data_out <= 0;
        end else begin
            case (state)
                0: begin // waiting state
                    if (send_data) begin
                        data_out <= 1; // send data
                        state <= 1; // move to sending state
                    end
                end
                1: begin // sending state
                    if (ack) begin
                        data_out <= 0; // clear data output
                        state <= 0; // move back to waiting state
                    end
                end
            endcase
        end
    end
endmodule