module uart_tx(
    input wire clk,
    input wire reset,
    input wire tx_en,
    input wire [7:0] data_in,
    output reg tx_out
);
    reg [3:0] bit_cnt;
    reg [7:0] shift_reg;
    reg transmitting;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            tx_out <= 1;
            bit_cnt <= 0;
            transmitting <= 0;
        end else if (tx_en && !transmitting) begin
            transmitting <= 1;
            shift_reg <= data_in;
            bit_cnt <= 0;
            tx_out <= 0; // Start bit
        end else if (transmitting) begin
            if (bit_cnt < 8) begin
                tx_out <= shift_reg[bit_cnt];
                bit_cnt <= bit_cnt + 1;
            end else begin
                tx_out <= 1; // Stop bit
                transmitting <= 0;
            end
        end
    end
endmodule