module top_module(input[5:0] yIn , output[5:0] yOut);assign yOut = yIn[5] ? ({yIn[5],!yIn[4],!yIn[3],!yIn[2],!yIn[1],!yIn[0]}+6'b1) : yIn;
endmodule