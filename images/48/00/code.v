module piso_shift_register(
    input clk,
    input reset,
    input load,
    input [7:0] parallel_in,

    output reg serial_out
);

reg [7:0] shift_reg;

always @(posedge clk or posedge reset) begin
    if (reset)
        shift_reg <= 8'b00000000;
    else if (load)
        shift_reg <= parallel_in;
    else
        shift_reg <= shift_reg >> 1;
end

always @(posedge clk or posedge reset) begin
    if (reset)
        serial_out <= 1'b0;
    else
        serial_out <= shift_reg[0];
end

endmodule