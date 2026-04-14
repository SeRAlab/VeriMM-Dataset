module top_module (
        input [3:0] y,
        input x,
        output reg Y0,
        output reg Y3);
        
assign Y0 = (y[3] & x) | (y[1] & ~x);
assign Y3 = (y[0] & x) | (y[2] & ~x);

endmodule