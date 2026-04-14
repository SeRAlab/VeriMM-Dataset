module top_module( 
    input p1a, p1b, p1c, p1d, p1e, p1f,
    output p1y,
    input p2a, p2b, p2c, p2d,
    output p2y );wire ag1, ag2, ag3, ag4;
    assign ag1 = p1a & p1b & p1c;
    assign ag2 = p2a & p2b;
    assign ag3 = p2c & p2d;
    assign ag4 = p1f & p1e & p1d;
    assign p2y = ag2 | ag3, p1y = ag1 | ag4;
    
endmodule