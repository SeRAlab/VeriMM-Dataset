module top_module(input[3:0] xIn , output[3:0] xOut);assign xOut = xIn[3] ? ({xIn[3],!xIn[2],!xIn[1],!xIn[0]}+4'b1) : xIn;
endmodule