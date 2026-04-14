module top_module (
        input [3:0] y,
        input z,
        output reg Y1,
        output reg Y2);
        
assign Y1 = (y[0] & z) | (y[3] & z);
assign Y2 = (y[1] & z) | (y[0] & ~z);

endmodule