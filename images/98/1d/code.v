module top_module(q, t, clk, reset);input clk, t, reset;
    output q;
    reg q;

    
    always @ (posedge(clk))
    begin
        if (reset)
            q = 1'b0;
            
        else
            q = q^t;
    end    
        
endmodule