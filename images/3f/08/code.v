module SISO_Shift_Register #(
    parameter WIDTH = 5
)(
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
            serial_out <= shift_reg[0];  // Output the least significant bit
            shift_reg <= {serial_in, shift_reg[WIDTH-1:1]}; // Shift left
        end
    end
endmodule