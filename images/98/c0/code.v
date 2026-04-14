module top_module (
        input [3:0] y,
        input e,
        output reg Y0,
        output reg Y3);
        
assign Y0 = (y[1] & ~e) | (y[2] & ~e) | (y[3] & ~e);
assign Y3 = (y[0] & ~e) | (y[2] & e);

endmodule