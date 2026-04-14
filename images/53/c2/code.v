module top_module (
        input [3:0] y,
        input x,
        output reg Y2,
        output reg Y3);
        
assign Y2 = (y[1] & x) | (y[0] & ~x);
assign Y3 = (y[2] & x) | (y[1] & ~x);

endmodule