module I2C_Controller (
    input clk,
    input rst,
    input [6:0] address,
    input [2:0] command, // 3'b000: READ, 3'b001: WRITE, 3'b010: STOP
    output reg ack,
    output reg [1:0] state // 2'b00: IDLE, 2'b01: ADDRESS_SENT, 2'b10: DATA_TRANSFER, 2'b11: ACK_RECEIVED
);

    // State encoding
    parameter IDLE = 2'b00;
    parameter ADDRESS_SENT = 2'b01;
    parameter DATA_TRANSFER = 2'b10;
    parameter ACK_RECEIVED = 2'b11;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= IDLE;
            ack <= 0;
        end else begin
            case (state)
                IDLE: begin
                    if (command != 3'b000) // If there is a command other than IDLE
                        state <= ADDRESS_SENT;
                end
                ADDRESS_SENT: begin
                    ack <= 1; // Generate ACK after sending address
                    state <= DATA_TRANSFER;
                end
                DATA_TRANSFER: begin
                    if (command == 3'b010) // If STOP command received
                        state <= IDLE;
                    else
                        state <= ACK_RECEIVED;
                end
                ACK_RECEIVED: begin
                    ack <= 0; // Clear ACK
                    state <= IDLE; // Go back to IDLE
                end
                default: state <= IDLE;
            endcase
        end
    end
endmodule