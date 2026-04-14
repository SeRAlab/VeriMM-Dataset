module spi_master (
    input wire clk,
    input wire cs,
    input wire [3:0] data_in,
    input wire miso,
    output reg mosi,
    output reg [3:0] data_out
);
    reg [1:0] bit_cnt;
    
    always @(posedge clk or negedge cs) begin
        if (!cs) begin
            bit_cnt <= 0;
            data_out <= 0;
            mosi <= data_in[3]; // Start with the MSB
        end else if (bit_cnt < 4) begin
            mosi <= data_in[3 - bit_cnt]; // Send data
            bit_cnt <= bit_cnt + 1;
        end
    end

    always @(negedge clk) begin
        if (cs) begin
            data_out[3 - bit_cnt] <= miso; // Receive data
        end
    end
endmodule