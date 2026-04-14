module d_latch (input D, input CLK, input EN, output reg Q);  
    always @(posedge CLK) begin  
        if (EN)  
            Q <= D;  
    end  
endmodule