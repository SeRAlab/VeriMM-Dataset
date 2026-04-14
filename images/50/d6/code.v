module uart_tx_8bit (
    input clk,
    input rst_n,
    input tx_en,
    input [7:0] tx_data,
    input baud_clk_en,
    output reg tx_out
);

reg [3:0] bit_index;
reg [8:0] shift_reg;
reg sending;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        tx_out <= 1'b1;
        bit_index <= 4'd0;
        shift_reg <= 9'd0;
        sending <= 1'b0;
    end else if (tx_en && !sending) begin
        shift_reg <= {1'b1, tx_data, 1'b0}; // Start bit, data, stop bit
        bit_index <= 4'd0;
        sending <= 1'b1;
    end else if (sending && baud_clk_en) begin
        tx_out <= shift_reg[0];
        shift_reg <= shift_reg >> 1;
        bit_index <= bit_index + 1;
        if (bit_index == 4'd9)
            sending <= 1'b0;
    end
end

endmodule