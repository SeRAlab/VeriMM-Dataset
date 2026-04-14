module register_32bit(
   input                clk,
   input                clr_n,
   input                en,
   input [31:0]         d,
 
   output reg [31:0]    q
);
    always@(posedge clk or negedge clr_n)begin
        if(!clr_n) q <= 32'd0;
        else if(en) q <= d;
    end
endmodule