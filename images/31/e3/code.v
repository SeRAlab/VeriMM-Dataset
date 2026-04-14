module deserializer (
    input wire clk,
    input wire rst,
    input wire serial_in,
    output reg [7:0] parallel_out,
    output reg valid
);
    reg [2:0] bit_count; // To count the bits received

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            bit_count <= 0;
            parallel_out <= 8'b0;
            valid <= 0;
        end else begin
            // Shift in the serial data
            parallel_out <= {parallel_out[6:0], serial_in};
            bit_count <= bit_count + 1;

            // When 8 bits have been received
            if (bit_count == 7) begin
                valid <= 1; // Indicate valid output
            end else if (bit_count == 8) begin
                valid <= 0; // Reset valid for next byte
                bit_count <= 0; // Reset bit count
            end
        end
    end
endmodule