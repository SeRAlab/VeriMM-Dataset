module serializer (
    input wire clk,
    input wire reset,
    input wire [7:0] data_in,
    input wire start,
    output reg serial_out
);
    reg [2:0] bit_count; // Counter for the bits being serialized
    reg [7:0] shift_reg; // Shift register for the input data

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            serial_out <= 0;
            bit_count <= 0;
            shift_reg <= 0;
        end else if (start) begin
            shift_reg <= data_in; // Load data into shift register
            bit_count <= 7;        // Set counter to the last bit index
        end else if (bit_count != 0) begin
            serial_out <= shift_reg[bit_count]; // Output the current bit
            bit_count <= bit_count - 1;         // Decrement the counter
        end else begin
            serial_out <= 0; // Output low when no bits are left to send
        end
    end
endmodule