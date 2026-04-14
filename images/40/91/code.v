module uart_tx(
    input clk,
    input rst,
    input start,
    input [7:0] data_in,
    output reg tx,
    output reg ready
);
    reg [3:0] bit_count;
    reg [9:0] shift_reg; // 1 start bit + 8 data bits + 1 stop bit
    reg sending;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            tx <= 1; // idle state
            ready <= 1;
            bit_count <= 0;
            shift_reg <= 0;
            sending <= 0;
        end else begin
            if (start && ready) begin
                shift_reg <= {1'b1, data_in, 1'b0}; // Load data with stop bit
                bit_count <= 10; // Total bits to send
                sending <= 1;
                ready <= 0;
            end

            if (sending) begin
                tx <= shift_reg[0]; // Transmit the least significant bit
                shift_reg <= shift_reg >> 1; // Shift right
                bit_count <= bit_count - 1;

                if (bit_count == 1) begin // All bits sent
                    sending <= 0;
                    ready <= 1; // Transmission complete
                end
            end
        end
    end
endmodule