module d_latch (input wire D, input wire EN, input wire RST, output reg Q);  
    always @(*) begin  
        if (RST)  
            Q <= 0;  
        else if (EN)  
            Q <= D;  
    end  
endmodule