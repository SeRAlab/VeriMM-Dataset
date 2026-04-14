module top_module(
        input I0,
        input C0,
        input C1,
        output y0,
        output y1,
        output y2,
        output y3
    );assign #3 y0 = (~C0) & (~C1) & I0;
    assign #3 y1 = (C0) & (~C1) & I0;
    assign #3 y2 = (~C0) & (C1) & I0;
    assign #3 y3 = (C0) & (C1) & I0;
    
endmodule