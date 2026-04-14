module top_module(
    input [31:0] input1,
    input [31:0] input2,
    input [3:0] aluCtr,
    output reg zero,
    output reg [31:0] aluRes
);always @(*) begin
        case (aluCtr)
            4'b000: aluRes = input1 + input2;
            4'b001: aluRes = input1 - input2;
            4'b010: aluRes = input1 & input2;
            4'b011: aluRes = input1 | input2;
            4'b100: aluRes = input1 ^ input2;
            4'b101: aluRes = input1 << input2;
            4'b110: aluRes = input1 >> input2;
            4'b111: aluRes = $signed(input1) >>> input2;
        endcase
        
        zero = (aluRes == 0);
    end

endmodule