module serializer (
    input wire clk,
    input wire reset,
    input wire [15:0] parallel_in,
    output reg serial_out
);
    reg [3:0] bit_counter; // 4 bits to count 0 to 15 (16 bits total)
    reg [15:0] shift_reg;  // Shift register for parallel input

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            bit_counter <= 0;
            serial_out <= 0;
            shift_reg <= 0;
        end else begin
            if (bit_counter < 16) begin
                serial_out <= shift_reg[15]; // Output the MSB of the shift register
                shift_reg <= {shift_reg[14:0], 1'b0}; // Shift left
                shift_reg[0] <= parallel_in[15 - bit_counter]; // Load next bit from parallel input
                bit_counter <= bit_counter + 1;
            end else begin
                serial_out <= 0; // After all bits are sent, keep output low
            end
        end
    end
endmodule