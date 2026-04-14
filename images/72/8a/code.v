module top_module (
        input [3:0] y,
        input x,
        output reg Y0,
        output reg Y2);
        
assign Y0 = (y[0] & ~x) | (y[3] & ~x);
assign Y2 = (y[1] & ~x) | (y[2] & x);

endmodule