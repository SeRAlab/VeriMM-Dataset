module uart_transmitter(
    input wire clk,
    input wire tx_enable,
    input wire [7:0] data_in,
    output reg tx_out
);
    reg [3:0] bit_count;
    reg [10:0] shift_reg; // 1 start bit + 8 data bits + 1 stop bit
    reg sending;

    always @(posedge clk) begin
        if (tx_enable && !sending) begin
            shift_reg <= {1'b1, data_in, 1'b0}; // start with 0 (start bit), then 8 data bits, then 1 (stop bit)
            bit_count <= 0;
            sending <= 1;
        end else if (sending) begin
            tx_out <= shift_reg[0]; // send the current bit
            shift_reg <= shift_reg >> 1; // shift the register
            bit_count <= bit_count + 1;
            if (bit_count == 10) begin
                sending <= 0; // done sending
            end
        end
    end
endmodule