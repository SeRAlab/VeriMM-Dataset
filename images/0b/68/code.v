module uart_controller (
    input clk,
    input rst,
    input transmit,
    input [7:0] data_in,
    output reg tx,
    output reg busy
);
    reg [3:0] bit_cnt;
    reg [7:0] data_buf;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            tx <= 1;
            busy <= 0;
            bit_cnt <= 0;
            data_buf <= 0;
        end else if (transmit && !busy) begin
            busy <= 1;
            data_buf <= data_in;
            bit_cnt <= 0;
            tx <= 0; // Start bit
        end else if (busy) begin
            if (bit_cnt < 8) begin
                tx <= data_buf[bit_cnt];
                bit_cnt <= bit_cnt + 1;
            end else begin
                tx <= 1; // Stop bit
                busy <= 0;
            end
        end
    end
endmodule