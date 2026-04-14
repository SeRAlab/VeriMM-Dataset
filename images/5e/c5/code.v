module d_ff(
   input                clk,
   input                reset,
   input                d,
 
   output reg           q
);

    always @(posedge clk) begin
        if (reset) q <= 1'b0;
        else q <= d;
    end

endmodule