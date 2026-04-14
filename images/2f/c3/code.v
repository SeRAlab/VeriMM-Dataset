module piso_shift_register (
    input clk,
    input shift,
    input load,
    input [3:0] parallel_data,
    output reg serial_out
);

reg [3:0] shift_reg;

always @(posedge clk) begin
    if (load) begin
        shift_reg <= parallel_data; // Load parallel data into shift register
    end else if (shift) begin
        serial_out <= shift_reg[3]; // Output the MSB
        shift_reg <= {shift_reg[2:0], 1'b0}; // Shift left
    end
end

endmodule