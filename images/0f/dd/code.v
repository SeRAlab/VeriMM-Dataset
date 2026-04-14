module siso_shift_register #(
    parameter WIDTH = 5
)(
    input wire clk,
    input wire rst,
    input wire serial_in,
    output reg serial_out
);

    reg [WIDTH-1:0] shift_reg;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            shift_reg <= 0;
            serial_out <= 0;
        end else begin
            // Shift left and input new serial bit
            shift_reg <= {shift_reg[WIDTH-2:0], serial_in};
            serial_out <= shift_reg[WIDTH-1]; // Output the last bit
        end
    end
endmodule