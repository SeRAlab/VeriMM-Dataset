module serializer_32bit (
    input clk,         // Clock input
    input reset,       // Reset signal
    input [31:0] data, // 32-bit parallel input
    output reg serial_out // 1-bit serialized output
);
    reg [5:0] bit_index; // to keep track of which bit to send

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            bit_index <= 0;
            serial_out <= 0;
        end else if (bit_index < 32) begin
            serial_out <= data[31 - bit_index]; // Send MSB first
            bit_index <= bit_index + 1; // Move to next bit
        end
    end
endmodule