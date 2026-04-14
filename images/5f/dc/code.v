module top_module (
        input [3:0] y,
        input b,
        output reg Y0,
        output reg Y3);
        
assign Y0 = (y[1] & ~b) | (y[2] & ~b) | (y[3] & ~b);
assign Y3 = (y[0] & ~b) | (y[2] & b);

endmodule