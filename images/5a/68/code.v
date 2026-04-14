module top_module(
    input clk,
    input serial_in,
    output reg serial_out,
    output reg q
);reg [2:0] shift_reg;
wire xor_input;

assign xor_input = shift_reg[2] ^ serial_in;

always @(posedge clk) begin
    shift_reg <= {shift_reg[1:0], xor_input};
    serial_out <= shift_reg[2];
    q <= shift_reg[0];
end

endmodule