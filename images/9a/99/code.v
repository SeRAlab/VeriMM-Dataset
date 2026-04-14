module uart_tx(
    input clk,
    input reset,
    input tx_start,
    input [7:0] tx_data,
    output reg tx_busy,
    output reg tx
);
    reg [3:0] bit_index;
    reg [7:0] shift_reg;
    reg [9:0] tx_frame;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            tx_busy <= 1'b0;
            tx <= 1'b1;
            bit_index <= 4'd0;
            shift_reg <= 8'd0;
            tx_frame <= 10'd0;
        end else if (tx_start && !tx_busy) begin
            tx_busy <= 1'b1;
            shift_reg <= tx_data;
            tx_frame <= {1'b1, tx_data, 1'b0};  // start bit (0), data, stop bit (1)
            bit_index <= 4'd0;
        end else if (tx_busy) begin
            if (bit_index < 4'd10) begin
                tx <= tx_frame[bit_index];
                bit_index <= bit_index + 1;
            end else begin
                tx_busy <= 1'b0;
                tx <= 1'b1;
            end
        end
    end
endmodule