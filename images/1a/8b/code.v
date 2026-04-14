module clock_gating(input clk, input control, input d, output reg q);  
    always @(posedge clk) begin  
        if (control)  
            q <= d;  
    end  
endmodule