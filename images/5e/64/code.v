module top_module(input [31:0] ReadData1,
                           input [31:0] ReadData2,
                           output reg Zero);always@(*)
        Zero = (ReadData1 - ReadData2 == 0) ? 1'b1 : 1'b0;

endmodule