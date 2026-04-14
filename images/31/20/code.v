module spi_controller (
    input wire clk,
    input wire mosi,
    input wire start,
    output reg miso,
    output reg data_ready
);
    reg [7:0] data_buffer;
    reg [2:0] bit_count;

    always @(posedge clk) begin
        if (start) begin
            bit_count <= 3'b000;
            data_buffer <= 8'b0;
            data_ready <= 1'b0;
        end else if (bit_count < 3'b111) begin
            data_buffer[bit_count] <= mosi;
            bit_count <= bit_count + 1;
        end else begin
            miso <= data_buffer[bit_count];
            data_ready <= 1'b1; // Data is ready to be sent
        end
    end
endmodule