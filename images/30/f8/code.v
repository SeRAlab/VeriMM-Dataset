module spi_master (
    input clk,
    input rst,
    input start,
    input [7:0] data_in,
    output reg sck,
    output reg mosi,
    output reg data_valid
);
    reg [2:0] bit_count;
    reg [7:0] data_shift;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            sck <= 0;
            mosi <= 0;
            data_valid <= 0;
            bit_count <= 3'b000;
            data_shift <= 8'b00000000;
        end else begin
            if (start) begin
                data_shift <= data_in;
                bit_count <= 3'b000;
                data_valid <= 1;
                sck <= 0; // Start with sck low
            end else if (data_valid) begin
                sck <= ~sck; // Toggle clock
                if (sck) begin // On rising edge of sck
                    mosi <= data_shift[7]; // Send the MSB first
                    data_shift <= {data_shift[6:0], 1'b0}; // Shift data 
                    bit_count <= bit_count + 1;
                    if (bit_count == 3'b111) begin
                        data_valid <= 0; // Transmission complete
                    end
                end
            end
        end
    end
endmodule