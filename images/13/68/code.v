module uart_transmitter (
    input clk,
    input rst,
    input tx_en,
    input [7:0] data_in,
    output reg tx,
    output reg busy
);
    reg [3:0] bit_count;
    reg [9:0] shift_reg; // 1 start bit + 8 data bits + 1 stop bit
    reg [15:0] baud_counter;
    parameter BAUD_RATE = 115200;
    parameter CLOCK_FREQ = 50000000; // 50 MHz
    localparam BAUD_LIMIT = CLOCK_FREQ / BAUD_RATE;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            tx <= 1; // idle high
            busy <= 0;
            bit_count <= 0;
            baud_counter <= 0;
        end else if (tx_en && !busy) begin
            // Load shift register with start bit, data, and stop bit
            shift_reg <= {1'b1, data_in, 1'b0}; // start bit low, stop bit high
            busy <= 1;
            bit_count <= 0;
            baud_counter <= 0;
        end else if (busy) begin
            baud_counter <= baud_counter + 1;
            if (baud_counter >= BAUD_LIMIT) begin
                baud_counter <= 0;
                tx <= shift_reg[0]; // output the LSB
                shift_reg <= {1'b1, shift_reg[9:1]}; // shift right
                bit_count <= bit_count + 1;
                if (bit_count == 9) begin // 10 bits transmitted
                    busy <= 0; // transmission complete
                    tx <= 1; // go back to idle
                end
            end
        end
    end
endmodule