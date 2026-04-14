module ofdm_modulator #(parameter N = 4) (
    input clk,
    input reset,
    input serial_in,
    output reg [N-1:0] parallel_out,
    output reg valid
);
    reg [N-1:0] data_buffer;
    reg [2:0] bit_count; // Assuming input data is N bits long

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            data_buffer <= 0;
            bit_count <= 0;
            parallel_out <= 0;
            valid <= 0;
        end else begin
            if (bit_count < N) begin
                data_buffer[bit_count] <= serial_in;
                bit_count <= bit_count + 1;
                valid <= 0; // Not valid until fully collected
            end else if (bit_count == N) begin
                parallel_out <= data_buffer;
                valid <= 1; // Indicate output is valid
                bit_count <= 0; // Reset for next input
            end
        end
    end
endmodule