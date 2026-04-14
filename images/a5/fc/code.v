module top_module (
        input [3:0] y,
        input a,
        output reg Y0,
        output reg Y3);
        
assign Y0 = (y[1] & ~a) | (y[2] & ~a) | (y[3] & ~a);
assign Y3 = (y[0] & ~a) | (y[2] & a);

endmodule