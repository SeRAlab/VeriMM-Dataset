module piso_shift_register (
    input wire clk,
    input wire load,
    input wire enable,
    input wire [4:0] parallel_in,
    output reg serial_out
);
    reg [4:0] shift_reg;
    integer count;

    always @(posedge clk) begin
        if (load) begin
            shift_reg <= parallel_in;  // Load parallel data into the shift register
            count <= 0;                 // Reset the count for shifting
        end else if (enable) begin
            if (count < 5) begin
                serial_out <= shift_reg[4]; // Output the MSB of shift register
                shift_reg <= {shift_reg[3:0], 1'b0}; // Shift left
                count <= count + 1; // Increment the count
            end else begin
                serial_out <= 1'b0; // After all bits have been shifted out
            end
        end
    end
endmodule