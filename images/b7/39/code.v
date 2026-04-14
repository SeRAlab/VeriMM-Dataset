module piso_shift_register_6bit(
    input clk,
    input rst,
    input load,
    input [5:0] parallel_in,

    output reg serial_out
);

reg [5:0] shift_reg;  // Internal shift register

// PISO Shift Register logic
always @(posedge clk) begin
    if (rst)
        shift_reg <= 6'b000000;
    else if (load)
        shift_reg <= parallel_in;
    else
        shift_reg <= {1'b0, shift_reg[5:1]};
end

// Serial output
always @(shift_reg) begin
    serial_out = shift_reg[0];
end

endmodule