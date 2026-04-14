module spi_controller (
    input wire clk,
    input wire reset,
    input wire cs,
    input wire mosi,
    output reg miso,
    output reg data_valid
);
    reg [7:0] data_out;
    reg [7:0] data_in;
    reg [2:0] bit_index;
    reg receiving;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            bit_index <= 3'b000;
            data_valid <= 0;
            receiving <= 0;
            miso <= 0;
        end else begin
            if (!cs) begin // active low chip select
                if (!receiving) begin
                    // Start receiving data
                    receiving <= 1;
                    bit_index <= 3'b000;
                    data_in <= 8'b0; // clear data in
                end else if (bit_index < 3'b111) begin
                    // Shift in data
                    data_in <= {data_in[6:0], mosi};
                    bit_index <= bit_index + 1;
                end else begin
                    // Finished receiving data
                    receiving <= 0;
                    data_valid <= 1;
                    data_out <= data_in; // Store received data
                end
            end else begin
                if (receiving) begin
                    data_valid <= 0; // Reset data valid if still receiving
                end
            end

            // Output data on MISO when not receiving
            if (!receiving) begin
                miso <= data_out[7 - bit_index];
            end
        end
    end
endmodule