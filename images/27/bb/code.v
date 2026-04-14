module uart_transmitter (
    input wire clk,
    input wire rst,
    input wire tx_en,
    input wire [7:0] data_in,
    output reg tx_out
);
    reg [3:0] bit_counter;
    reg [9:0] shift_reg; // 1 start bit + 8 data bits + 1 stop bit
    reg transmitting;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            tx_out <= 1; // idle state
            bit_counter <= 0;
            shift_reg <= 0;
            transmitting <= 0;
        end else if (tx_en && !transmitting) begin
            // Load data into shift register
            shift_reg <= {1'b1, data_in, 1'b0}; // start bit 0, data, stop bit 1
            transmitting <= 1;
            bit_counter <= 0;
        end else if (transmitting) begin
            if (bit_counter < 10) begin
                tx_out <= shift_reg[0]; // transmit the current bit
                shift_reg <= shift_reg >> 1; // shift right
                bit_counter <= bit_counter + 1;
            end else begin
                transmitting <= 0; // transmission complete
                tx_out <= 1; // return to idle state
            end
        end
    end
endmodule