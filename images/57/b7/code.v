module top_module (
        input [3:0] y,
        input x,
        output reg Y0,
        output reg Y1);
        
assign Y0 = (y[2] & ~x) | (y[1] & ~x) | (y[3] & ~x);
assign Y1 = (y[0] & x) | (y[3] & x);

endmodule