module shift_register_16bit (q, clk, reset, load, d);
   input clk, reset, load;
   input [15:0] d;
   output [15:0] q;
   
   reg [15:0] q;

always @(posedge clk or posedge reset) begin
    if (reset) 
        q <= 16'b0000000000000000;
    else 
        if (load)
            q <= d;
        else
            q <= q << 1;
end

endmodule