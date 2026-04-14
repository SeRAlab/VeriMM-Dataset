module SISO_Shift_Register #(parameter WIDTH = 8) (
    input clk,
    input serial_in,
    output reg serial_out
);
    reg [WIDTH-1:0] shift_reg;

    always @(posedge clk) begin
        shift_reg <= {shift_reg[WIDTH-2:0], serial_in}; // Shift left
        serial_out <= shift_reg[WIDTH-1]; // Output the MSB
    end
endmodule