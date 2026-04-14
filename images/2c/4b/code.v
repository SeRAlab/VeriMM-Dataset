module siso_shift_register #(parameter WIDTH = 5) (
    input wire clk,
    input wire reset_n,
    input wire serial_in,
    output reg serial_out
);
    reg [WIDTH-1:0] shift_reg;

    always @(posedge clk or negedge reset_n) begin
        if (!reset_n) begin
            shift_reg <= {WIDTH{1'b0}};
            serial_out <= 1'b0;
        end else begin
            serial_out <= shift_reg[0]; // Output the oldest bit
            shift_reg <= {serial_in, shift_reg[WIDTH-1:1]}; // Shift left and insert new bit
        end
    end
endmodule