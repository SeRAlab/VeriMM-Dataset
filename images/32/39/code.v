module PISO_Shift_Register (
    input wire clk,
    input wire load,
    input wire shift,
    input wire [4:0] parallel_in,
    output reg serial_out
);
    reg [4:0] shift_reg;
    integer count;

    always @(posedge clk) begin
        if (load) begin
            shift_reg <= parallel_in; // Load the parallel input
            count <= 5; // Set count to number of bits to shift
        end else if (shift && count > 0) begin
            serial_out <= shift_reg[4]; // Output the most significant bit
            shift_reg <= {shift_reg[3:0], 1'b0}; // Shift left
            count <= count - 1; // Decrease count
        end
    end
endmodule