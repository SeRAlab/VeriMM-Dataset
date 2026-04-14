module verified_d_ff(clk, d, q);

    input clk;
    input d;
    output reg q;

    always @(posedge clk)
        begin
            q <= d;
        end  

endmodule