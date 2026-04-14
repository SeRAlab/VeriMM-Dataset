module PISO (
    input wire clk,
    input wire load,
    input wire shift,
    input wire [7:0] parallel_in,
    output reg serial_out
);
    reg [7:0] shift_reg;

    always @(posedge clk) begin
        if (load) begin
            shift_reg <= parallel_in; // Load the input data
        end else if (shift) begin
            serial_out <= shift_reg[7]; // Output the MSB
            shift_reg <= shift_reg << 1; // Shift left
        end
    end
endmodule