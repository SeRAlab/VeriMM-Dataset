module ofdm_modulator (
    input clk,
    input reset,
    input serial_in,
    output reg [1:0] qpsk_out,
    output reg data_valid
);
    reg [1:0] shift_reg;
    reg [2:0] bit_count;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            shift_reg <= 2'b00;
            bit_count <= 3'b000;
            data_valid <= 0;
        end else begin
            shift_reg <= {shift_reg[0], serial_in}; // Shift in the new bit
            bit_count <= bit_count + 1;
            if (bit_count == 2) begin
                qpsk_out <= shift_reg; // Output the QPSK symbol
                data_valid <= 1;
                bit_count <= 0; // Reset bit count after output
            end else begin
                data_valid <= 0; // No valid data until we have 2 bits
            end
        end
    end
endmodule