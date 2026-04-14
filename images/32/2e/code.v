module spi_master (
    input wire clk,
    input wire reset,
    input wire cs, // Chip Select
    input wire mosi, // Master Out Slave In
    output reg miso, // Master In Slave Out
    output reg ready, // Ready signal
    output reg [7:0] data_out // Data to be sent
);
    reg [2:0] bit_count;
    reg [7:0] data_in;
    reg state; // 0: idle, 1: transmitting

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= 0;
            bit_count <= 0;
            ready <= 1;
            miso <= 0;
            data_out <= 8'b0;
        end else if (!cs) begin // Active low chip select
            if (state == 0) begin
                data_in <= 8'b0; // Clear data_in on new transaction
                state <= 1; // Start transmission
                ready <= 0; // Not ready while transmitting
                bit_count <= 7; // Start with the MSB
            end else if (state == 1) begin
                miso <= data_out[bit_count]; // Send out the current bit
                if (bit_count == 0) begin
                    state <= 0; // Done transmitting
                    ready <= 1; // Signal ready
                end else begin
                    bit_count <= bit_count - 1; // Move to next bit
                end
            end
        end
    end
endmodule