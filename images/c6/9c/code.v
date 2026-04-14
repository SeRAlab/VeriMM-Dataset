module ones_complement(input [3:0] in, output [3:0] out);
    assign out = in ^ 4'b1111;
endmodule