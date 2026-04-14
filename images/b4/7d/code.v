module top_module (
        input [3:0] y,
        input c,
        output reg Y0,
        output reg Y2);
        
assign Y0 = (y[1] & ~c) | (y[2] & ~c) | (y[3] & ~c);
assign Y2 = (y[1] & c) | (y[0] & ~c);

endmodule