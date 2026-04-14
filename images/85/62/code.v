module top_module (
        input [3:0] y,
        input f,
        output reg Y1,
        output reg Y2);
        
assign Y1 = (y[0] & f) | (y[3] & f);
assign Y2 = (y[1] & f) | (y[0] & ~f);

endmodule