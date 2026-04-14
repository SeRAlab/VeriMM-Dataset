module sr_latch (input wire S, input wire R, input wire clk, output reg Q);  
    always @(posedge clk) begin  
        if (S && !R)  
            Q <= 1;  
        else if (!S && R)  
            Q <= 0;  
        // If both S and R are 0, Q remains unchanged.  
    end  
endmodule