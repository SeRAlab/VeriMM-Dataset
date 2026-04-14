module top_module(
    input [31:0] in,
    input clk,              // Added clk input
    output reg [31:0] out );// Changed output to reg type

    reg [7:0] shift_reg [0:3];
    reg [1:0] select;

    always @(*) begin
        shift_reg[0] = in[7:0];
        shift_reg[1] = in[15:8];
        shift_reg[2] = in[23:16];
        shift_reg[3] = in[31:24];

        case (select)
            2'b00: out = {shift_reg[3], shift_reg[2], shift_reg[1], shift_reg[0]};
            2'b01: out = {shift_reg[2], shift_reg[1], shift_reg[0], shift_reg[3]};
            2'b10: out = {shift_reg[1], shift_reg[0], shift_reg[3], shift_reg[2]};
            2'b11: out = {shift_reg[0], shift_reg[3], shift_reg[2], shift_reg[1]};
        endcase
    end

    always @(posedge clk) begin
        select <= select + 1;
    end

endmodule