module toggle_ff(clk, t, q);  

    input  clk;  
    input t;  
    output  q;  
    reg   q; 

    always @(posedge clk)
          begin
            if (t)
                q <= ~q;
          end  

endmodule