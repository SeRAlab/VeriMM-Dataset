module i2c_controller (
    input wire clk,
    input wire start,
    input wire stop,
    input wire [7:0] data_in,
    output reg sda,
    output reg scl,
    output reg ack,
    output reg [7:0] data_out
);

    reg [3:0] state;
    reg [3:0] bit_count;
    
    parameter IDLE = 4'b0000,
              START = 4'b0001,
              SEND_DATA = 4'b0010,
              ACK = 4'b0011,
              STOP = 4'b0100;

    always @(posedge clk) begin
        case (state)
            IDLE: begin
                sda <= 1;   // Idle state, SDA high
                scl <= 1;   // Idle state, SCL high
                ack <= 0;   // No ACK
                if (start) begin
                    state <= START;
                end
            end

            START: begin
                sda <= 0;   // Start condition
                state <= SEND_DATA;
                bit_count <= 0;
            end

            SEND_DATA: begin
                if (bit_count < 8) begin
                    sda <= data_in[7 - bit_count]; // Send data bit
                    scl <= 0;                      // SCL low
                    scl <= 1;                      // SCL high
                    bit_count <= bit_count + 1;
                end else begin
                    state <= ACK;
                end
            end

            ACK: begin
                scl <= 0;                     // SCL low for ACK
                ack <= 1;                     // Assume we received an ACK
                scl <= 1;                     // SCL high for ACK
                state <= STOP;
            end

            STOP: begin
                sda <= 0;                     // Prepare for stop
                scl <= 1;                     // SCL high
                sda <= 1;                     // Stop condition
                state <= IDLE;                // Go back to IDLE
            end
        endcase
    end

endmodule