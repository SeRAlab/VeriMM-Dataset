module ARQ (
    input clk,
    input reset,
    input [7:0] data_in,
    input ack,
    output reg [7:0] data_out,
    output reg send,
    output reg error
);
    reg [1:0] state; // 0: idle, 1: send, 2: wait_ack, 3: resend
    reg [7:0] sent_data;
    parameter IDLE = 2'b00, SEND = 2'b01, WAIT_ACK = 2'b10, RESEND = 2'b11;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE;
            send <= 0;
            data_out <= 0;
            error <= 0;
        end else begin
            case (state)
                IDLE: begin
                    if (data_in !== 8'bx) begin
                        sent_data <= data_in; // Load new data
                        state <= SEND; // Move to send state
                        send <= 1; // Indicate sending
                    end
                end
                SEND: begin
                    data_out <= sent_data; // Output the data
                    state <= WAIT_ACK; // Move to wait for acknowledgment
                end
                WAIT_ACK: begin
                    if (ack) begin
                        send <= 0; // Acknowledged, stop sending
                        state <= IDLE; // Go back to idle
                    end else begin
                        error <= 1; // Error detected
                        state <= RESEND; // Move to resend state
                    end
                end
                RESEND: begin
                    data_out <= sent_data; // Resend the data
                    send <= 1; // Indicate sending again
                    state <= WAIT_ACK; // Wait for acknowledgment again
                end
                default: state <= IDLE; // Fallback to idle
            endcase
        end
    end
endmodule