module top_module(
    input sel1,
    input sel0,
    output reg [15:0] out
);// Implementing the 4-to-16 decoder using AND gates and inverters
    assign out[0]  = ~(sel1 | sel0);
    assign out[1]  = ~(sel1 | ~sel0);
    assign out[2]  = ~(~sel1 | sel0);
    assign out[3]  = ~(~sel1 | ~sel0);
    assign out[4]  = ~(sel1 & sel0);
    assign out[5]  = ~(sel1 & ~sel0);
    assign out[6]  = ~(~sel1 & sel0);
    assign out[7]  = ~(~sel1 & ~sel0);
    assign out[8]  = ~(sel1 & sel0 & ~sel0);
    assign out[9]  = ~(sel1 & ~sel0 & ~sel1);
    assign out[10] = ~(~sel1 & sel0 & ~sel0);
    assign out[11] = ~(~sel1 & ~sel0 & ~sel1);
    assign out[12] = ~(sel1 & sel0 & ~sel1);
    assign out[13] = ~(sel1 & ~sel0 & sel1);
    assign out[14] = ~(~sel1 & sel0 & sel1);
    assign out[15] = ~(~sel1 & ~sel0 & sel1);

endmodule