module top_module(input wire A, B, C, D,
                output wire [6:0]segs);assign segs[0] = (!A && C) || (A && !B && !C) || 
                              (!B && !C && !D) || (!A && B && D);

    assign segs[1] = (!A && !B) || (!B && !C) || 
                              (!A && !C && !D) || (!A && C && D);

    assign segs[2] = (!A && B) || (!A && !C) || (!A && D) || (!B && !C);

    assign segs[3] = (A && !B && !C) || (!A && C && !D) || 
                              (!A && !B && C) || (!B && !C && !D) ||
                              (!A && B && !C && D);

    assign segs[4] = (!A && C && !D) || (!B && !C && !D);

    assign segs[5] = (A && !B && !C) || (!A && B && !C) || 
                              (!B && !C && !D) || (!A && B && !D);

    assign segs[6] = (A && !B && !C) || (!A && !B && C) || 
                              (!A && B && !C) || (!A && C && !D);

endmodule