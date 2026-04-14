module top_module(
    input [254:0] in, // 255-bit input vector for population count circuit
    input [31:0] in_swap, // 32-bit input vector for byte swapping module
    output [7:0] count_out, // 8-bit output from population count circuit
    output [31:0] swap_out, // 32-bit output from byte swapping module
    output [7:0] sum_out // 8-bit output from functional module
);// Population count circuit
reg [7:0] count_reg;
reg [254:0] shift_reg;
reg [7:0] adder_out;

always @(*) begin
    shift_reg = {shift_reg[253:0], in};
    adder_out = adder_out + shift_reg[0];
    count_reg = adder_out;
end

assign count_out = count_reg;

// Byte swapping module
reg [7:0] swap_reg [3:0];
reg [31:0] swap_out_reg;

always @(*) begin
    swap_reg[0] = in_swap[31:24];
    swap_reg[1] = in_swap[23:16];
    swap_reg[2] = in_swap[15:8];
    swap_reg[3] = in_swap[7:0];
    swap_out_reg = {swap_reg[3], swap_reg[2], swap_reg[1], swap_reg[0]};
end

assign swap_out = swap_out_reg;

// Functional module
reg [7:0] sum_reg;

always @(*) begin
    sum_reg = count_out + swap_out[31];
end

assign sum_out = sum_reg;

endmodule