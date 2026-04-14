module top_module (
        input [3:0] y,
        input x,
        output reg Y1,
        output reg Y3);
        
assign Y1 = (y[0] & ~x) | (y[2] & x);
assign Y3 = (y[1] & x) | (y[3] & ~x);

endmodule