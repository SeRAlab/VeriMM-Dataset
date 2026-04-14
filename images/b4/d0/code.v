module d_ff_sync_reset(clk, reset, d, q);

    input  clk;  
    input  reset;  
    input  d;
    output  q;
    reg   q; 

    always @(posedge clk)
          begin
            if (reset)
                q <= 0;
            else
                q <= d;
          end  

endmodule