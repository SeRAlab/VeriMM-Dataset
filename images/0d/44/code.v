module uart_tx (
    input wire clk,
    input wire rst,
    input wire tx_en,
    input wire [7:0] data,
    output reg tx
);
    reg [3:0] bit_cnt;
    reg [7:0] shift_reg;
    reg sending;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            tx <= 1'b1; // Idle state (high)
            bit_cnt <= 0;
            shift_reg <= 0;
            sending <= 0;
        end else if (tx_en && !sending) begin
            sending <= 1;
            shift_reg <= data;
            bit_cnt <= 0;
            tx <= 1'b0; // Start bit (low)
        end else if (sending) begin
            if (bit_cnt < 8) begin
                tx <= shift_reg[bit_cnt]; // Transmit data bits
                bit_cnt <= bit_cnt + 1;
            end else begin
                tx <= 1'b1; // Stop bit (high)
                sending <= 0; // Transmission complete
            end
        end
    end
endmodule