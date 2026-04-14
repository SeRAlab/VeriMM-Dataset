module i2c_master (
    input clk,
    input start,
    input stop,
    input [7:0] data_in,
    output reg sda,
    output reg scl,
    output reg ack
);
    reg [3:0] state;
    reg [7:0] data;
    reg bit_cnt;

    parameter IDLE = 0, START = 1, SEND = 2, ACK = 3, STOP = 4;

    always @(posedge clk) begin
        case(state)
            IDLE: begin
                sda <= 1;
                scl <= 1;
                ack <= 0;
                if (start) begin
                    state <= START;
                end
            end
            START: begin
                sda <= 0; // Start condition
                state <= SEND;
                bit_cnt <= 0;
                data <= data_in;
            end
            SEND: begin
                scl <= 0; // Clock low
                sda <= data[7 - bit_cnt]; // Send data
                bit_cnt <= bit_cnt + 1;
                if (bit_cnt == 7) begin
                    state <= ACK;
                end
            end
            ACK: begin
                scl <= 1; // Clock high for ACK
                ack <= 1; // Acknowledge signal
                state <= STOP;
            end
            STOP: begin
                scl <= 0;
                sda <= 0; // Preparing for stop condition
                sda <= 1; // Stop condition
                state <= IDLE;
            end
        endcase
    end
endmodule