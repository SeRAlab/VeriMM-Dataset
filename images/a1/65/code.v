module top_module(
    input clk,
    input rst,
    input [7:0] tb_rx_data,
    input tb_rx_done,
    output reg tb_tx_start,
    output reg tb_tx_busy,
    output reg [7:0] tb_tx_data
);reg [7:0] buffer;
reg [2:0] buffer_count;
reg [2:0] transmit_count;
reg [7:0] transmit_data;

always @(posedge clk) begin
    if (rst) begin
        buffer_count <= 0;
        transmit_count <= 0;
        tb_tx_start <= 0;
        tb_tx_busy <= 0;
        tb_tx_data <= 0;
    end else begin
        if (tb_rx_done && (buffer_count < 3)) begin
            buffer[buffer_count] <= tb_rx_data;
            buffer_count <= buffer_count + 1;
        end

        if (tb_tx_start && !tb_tx_busy && (buffer_count > 0)) begin
            transmit_data <= buffer[transmit_count];
            tb_tx_data <= transmit_data;
            transmit_count <= transmit_count + 1;
            buffer_count <= buffer_count - 1;
            tb_tx_start <= 0;
            tb_tx_busy <= 1;
        end

        if (tb_tx_busy) begin
            tb_tx_busy <= 0;
        end
    end
end

endmodule