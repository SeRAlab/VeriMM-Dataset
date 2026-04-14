module top_module(
    input clock,
    input reset,
    input [7:0] tx_data,
    input new_tx_data,
    input ce_16,
    output reg ser_out,
    output reg ce_1
);reg [3:0] count16;
reg [3:0] bit_count;
reg [8:0] data_buf;
reg tx_busy;

always @(posedge clock) begin
    if (reset) begin
        tx_busy <= 1'b0;
        bit_count <= 4'h0;
        data_buf <= 9'b0;
        count16 <= 4'b0;
        ser_out <= 1'b1;
        ce_1 <= 1'b0;
    end
    else begin
        if (~tx_busy & new_tx_data) begin
            tx_busy <= 1'b1;
            data_buf <= {tx_data, 1'b0};
        end
        else if (tx_busy & ce_1) begin
            data_buf <= {1'b1, data_buf[8:1]};
            bit_count <= bit_count + 4'h1;
            if (bit_count == 4'h9) begin
                tx_busy <= 1'b0;
                bit_count <= 4'h0;
            end
        end
        if (tx_busy & ce_16) begin
            count16 <= count16 + 4'b1;
            if (count16 == 4'b1111) begin
                ce_1 <= 1'b1;
                count16 <= 4'b0;
            end
        end
        else begin
            count16 <= 4'b0;
            ce_1 <= 1'b0;
        end
        if (tx_busy) begin
            ser_out <= data_buf[0];
        end
        else begin
            ser_out <= 1'b1;
        end
    end
end

endmodule