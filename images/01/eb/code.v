module PISO (
    input clk,
    input load,
    input shift,
    input [4:0] parallel_in,
    output reg serial_out
);
    reg [4:0] shift_reg;

    always @(posedge clk) begin
        if (load) begin
            shift_reg <= parallel_in; // Load parallel input
        end else if (shift) begin
            serial_out <= shift_reg[0]; // Output the least significant bit
            shift_reg <= shift_reg >> 1; // Shift right
        end
    end
endmodule