module arq_system(
    input clk,
    input reset,
    input data_in,
    output reg data_out,
    output reg ack,
    output reg nack
);
    reg [1:0] state; // 0: idle, 1: sending, 2: wait_ack, 3: error
    reg error_detected;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= 0;
            data_out <= 0;
            ack <= 0;
            nack <= 0;
            error_detected <= 0;
        end else begin
            case (state)
                0: begin // idle
                    data_out <= data_in;
                    ack <= 0;
                    nack <= 0;
                    state <= 1;
                end
                1: begin // sending
                    // Simulate random error detection
                    error_detected <= ($random % 10 == 0); // 10% chance of error
                    if (error_detected) begin
                        state <= 3; // go to error state
                    end else begin
                        ack <= 1; // simulate successful send
                        state <= 2; // wait for ack
                    end
                end
                2: begin // wait for ack
                    if (ack) begin
                        state <= 0; // go back to idle
                    end
                end
                3: begin // error detected
                    nack <= 1; // send nack
                    state <= 0; // go back to idle
                end
            endcase
        end
    end
endmodule