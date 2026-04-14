module serializer (
    input clk,               // Clock signal
    input rst,               // Reset signal
    input [31:0] data_in,    // 32-bit input data
    output reg serial_out     // Serial output
);
    reg [4:0] bit_index;     // 5-bit index to track current bit position

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            bit_index <= 0;   // Reset the bit index
            serial_out <= 0;  // Reset output
        end else begin
            if (bit_index < 32) begin
                serial_out <= data_in[31 - bit_index]; // Output the current bit
                bit_index <= bit_index + 1; // Increment the bit index
            end
        end
    end
endmodule