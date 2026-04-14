module ofdm_transmitter (
    input wire clk,
    input wire reset,
    input wire serial_data,
    output reg [1:0] qpsk_symbol,
    output reg data_valid
);
    reg [1:0] bit_buffer;
    reg [1:0] bit_count;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            bit_buffer <= 2'b00;
            bit_count <= 2'b00;
            qpsk_symbol <= 2'b00;
            data_valid <= 0;
        end else begin
            if (bit_count < 2) begin
                bit_buffer[bit_count] <= serial_data;
                bit_count <= bit_count + 1;
            end else begin
                qpsk_symbol <= bit_buffer;
                data_valid <= 1;
                bit_count <= 0;  // Reset for the next two bits
            end
        end
    end
endmodule