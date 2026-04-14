module stop_and_wait (
    input clk,
    input reset,
    input send_data,
    output reg ack,
    output reg data_out
);
    reg [1:0] state;
    parameter IDLE = 2'b00, SEND = 2'b01, WAIT_ACK = 2'b10;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE;
            data_out <= 0;
            ack <= 0;
        end else begin
            case (state)
                IDLE: begin
                    if (send_data) begin
                        data_out <= 1; // Sending data
                        state <= SEND;
                    end
                end
                SEND: begin
                    state <= WAIT_ACK; // Move to waiting for ack
                end
                WAIT_ACK: begin
                    ack <= 1; // Acknowledge received
                    state <= IDLE; // Go back to IDLE
                    data_out <= 0; // Clear data_out
                end
            endcase
        end
    end
endmodule