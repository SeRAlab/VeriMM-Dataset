module top_module (
        input [3:0] y,
        input d,
        output reg Y1,
        output reg Y3);
        
assign Y1 = (y[0] & d) | (y[3] & d);
assign Y3 = (y[0] & ~d) | (y[2] & d);

endmodule