module top_module (
        input [3:0] y,
        input h,
        output reg Y2,
        output reg Y3);
        
assign Y2 = (y[1] & h) | (y[3] & ~h);
assign Y3 = (y[0] & ~h) | (y[2] & h);

endmodule