module I2C_Master(
    input wire clk,
    input wire start,
    input wire [7:0] data_in,
    output reg ack_out,
    output reg scl,
    inout wire sda
);

reg [3:0] state;
reg [7:0] data_buffer;
reg [2:0] bit_cnt;

localparam IDLE = 0,
           START = 1,
           SEND = 2,
           ACK = 3,
           STOP = 4;

assign sda = (state == SEND) ? data_buffer[7] : 1'bz; // Data output on SDA line if sending

always @(posedge clk) begin
    case(state)
        IDLE: begin
            scl <= 1;
            ack_out <= 1;
            if (start) begin
                state <= START;
                bit_cnt <= 0;
                data_buffer <= data_in;
            end
        end
        START: begin
            scl <= 0; // SCL low for start condition
            state <= SEND;
        end
        SEND: begin
            if (bit_cnt < 8) begin
                scl <= 1; // SCL high for data transmission
                data_buffer <= {data_buffer[6:0], 1'b0}; // Shift left to send next bit
                bit_cnt <= bit_cnt + 1;
            end else begin
                state <= ACK; // Move to ACK state after sending data
            end
        end
        ACK: begin
            ack_out <= sda; // Read ACK from slave
            state <= STOP; // Move to STOP state
        end
        STOP: begin
            scl <= 0; // SCL low for stop condition
            state <= IDLE; // Return to idle state
        end
    endcase
end

endmodule