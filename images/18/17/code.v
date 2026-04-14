module PISO(
    input clk,
    input load,
    input shift,
    input [7:0] parallel_in,
    output reg serial_out
);
    reg [7:0] shift_reg;

    always @(posedge clk) begin
        if (load) begin
            shift_reg <= parallel_in; // Load data into the shift register
        end else if (shift) begin
            serial_out <= shift_reg[7]; // Output the most significant bit
            shift_reg <= {shift_reg[6:0], 1'b0}; // Shift left
        end
    end
endmodule