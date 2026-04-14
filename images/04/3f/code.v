module spi_controller (
    input wire clk,
    input wire reset,
    input wire cs_n,  // Active low chip select
    input wire mosi,
    output reg miso
);
    reg [7:0] data_in;
    reg [7:0] data_out;
    reg [2:0] bit_count;
    reg active;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            bit_count <= 3'b000;
            active <= 1'b0;
            miso <= 1'b0;
        end else if (!cs_n) begin
            if (!active) begin
                active <= 1'b1; // Start of transmission
                bit_count <= 3'b000; // Reset bit count
            end else begin
                data_in[bit_count] <= mosi; // Sample the input
                bit_count <= bit_count + 1;
                if (bit_count == 3'b111) begin
                    data_out <= data_in; // On the last bit, prepare the output
                    miso <= data_out[bit_count]; // Set MISO to the last bit
                end else begin
                    miso <= data_out[bit_count]; // Output current bit
                end
            end
        end else begin
            active <= 1'b0; // End of transmission
            miso <= 1'bz; // High impedance when not active
        end
    end
endmodule