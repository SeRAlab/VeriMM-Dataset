module SISO_ShiftRegister #(parameter WIDTH = 8) (
    input wire clk,
    input wire reset,
    input wire serial_in,
    output reg serial_out
);
    reg [WIDTH-1:0] shift_reg;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            shift_reg <= 0;
            serial_out <= 0;
        end else begin
            shift_reg <= {shift_reg[WIDTH-2:0], serial_in}; // Shift left and input new bit
            serial_out <= shift_reg[0]; // Output the oldest bit
        end
    end
endmodule