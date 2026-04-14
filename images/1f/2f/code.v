module stop_and_wait(
    input wire clk,
    input wire rst,
    input wire send_data,
    input wire ack,
    output reg send_done,
    output reg data_out
);
    reg [1:0] state;

    parameter IDLE = 2'b00;
    parameter SEND = 2'b01;
    parameter WAIT_ACK = 2'b10;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= IDLE;
            send_done <= 0;
            data_out <= 0;
        end else begin
            case (state)
                IDLE: begin
                    if (send_data) begin
                        data_out <= 1; // Simulate data being sent
                        send_done <= 0;
                        state <= SEND;
                    end
                end
                SEND: begin
                    send_done <= 1; // Data has been sent
                    if (ack) begin
                        data_out <= 0; // Clear data
                        state <= IDLE; // Go back to IDLE
                    end
                end
                default: state <= IDLE;
            endcase
        end
    end
endmodule