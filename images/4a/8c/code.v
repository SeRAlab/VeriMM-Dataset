module top_module(input data1x, data0x, sel, output result);assign result = (data0x & ~sel) | (data1x	& sel);
endmodule