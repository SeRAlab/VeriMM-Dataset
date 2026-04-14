module uart_transmitter (
    input wire clk,         // baud rate clock
    input wire start,       // start signal
    input wire [7:0] data,  // 8-bit parallel data input
    output reg tx          // serial output
);

reg [3:0] state;         // state to control the state machine
reg [3:0] bit_index;     // index for the current bit being sent

parameter IDLE = 4'b0000, START_BIT = 4'b0001, DATA_BITS = 4'b0010, STOP_BIT = 4'b0011;

always @(posedge clk) begin
    case (state)
        IDLE: begin
            tx <= 1; // idle high
            if (start) begin
                state <= START_BIT;
                bit_index <= 0; // reset bit index
            end
        end
        START_BIT: begin
            tx <= 0; // start bit
            state <= DATA_BITS;
        end
        DATA_BITS: begin
            tx <= data[bit_index]; // send data bit
            if (bit_index == 7) begin
                state <= STOP_BIT;
            end else begin
                bit_index <= bit_index + 1;
            end
        end
        STOP_BIT: begin
            tx <= 1; // stop bit
            state <= IDLE;
        end
    endcase
end

endmodule