module spi_master (
    input wire clk,
    input wire enable,
    input wire [7:0] data_in,
    output reg [7:0] data_out,
    output reg mosi,
    input wire miso
);
    reg [3:0] bit_count;
    
    always @(posedge clk) begin
        if (enable) begin
            mosi <= data_in[7 - bit_count]; // Transmit data bit by bit
            bit_count <= bit_count + 1;
            if (bit_count == 8) begin
                data_out <= {data_out[6:0], miso}; // Receive data
                bit_count <= 0; // Reset bit count
            end
        end else begin
            bit_count <= 0; // Reset if not enabled
        end
    end
endmodule