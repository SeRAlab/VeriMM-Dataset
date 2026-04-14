module spi_controller(
    input wire clk,
    input wire reset,
    input wire cs, // Chip Select
    input wire mosi, // Master Out Slave In
    output reg miso, // Master In Slave Out
    output reg [7:0] data_out,
    input wire [7:0] data_in,
    output reg data_ready
);
    reg [3:0] bit_counter;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            bit_counter <= 0;
            miso <= 0;
            data_out <= 0;
            data_ready <= 0;
        end else if (cs) begin
            if (bit_counter < 8) begin
                data_out <= {data_out[6:0], mosi}; // Shift in data
                miso <= data_in[7 - bit_counter]; // Send data out
                bit_counter <= bit_counter + 1;
            end else begin
                data_ready <= 1; // Indicate data is ready after 8 bits
                bit_counter <= 0; // Reset counter
            end
        end
    end
endmodule