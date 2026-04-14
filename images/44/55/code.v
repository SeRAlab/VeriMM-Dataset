module top_module(
    input in1,
    input in2,
    input in3,
    input in4,
    input in5,
    input [2:0] op,
    output reg out // Change output to reg type
);wire and_out, or_out, xor_out, nand_out, nor_out;

    assign and_out = in1 & in2 & in3 & in4 & in5;
    assign or_out = in1 | in2 | in3 | in4 | in5;
    assign xor_out = in1 ^ in2 ^ in3 ^ in4 ^ in5;
    assign nand_out = ~(in1 & in2 & in3 & in4 & in5);
    assign nor_out = ~(in1 | in2 | in3 | in4 | in5);

    always @(*) begin
        case (op)
            3'b000: out = and_out;
            3'b001: out = or_out;
            3'b010: out = xor_out;
            3'b011: out = nand_out;
            3'b100: out = nor_out;
            default: out = 1'b0; // default to 0 if invalid op
        endcase
    end

endmodule