module sipo_shift_register (
    input clk,
    input reset,
    input serial_in,
    output reg [7:0] parallel_out
);
    reg [2:0] bit_counter; // To count the number of bits shifted

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            parallel_out <= 8'b0;
            bit_counter <= 3'b000;
        end else if (bit_counter < 3'd8) begin
            parallel_out <= {parallel_out[6:0], serial_in}; // Shift in the new bit
            bit_counter <= bit_counter + 1; // Increment the bit counter
        end
    end
endmodule