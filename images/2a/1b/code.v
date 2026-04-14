module D_latch (input D, input CLK, output reg Q);  
    always @(posedge CLK) begin  
        Q <= D;  
    end  
endmodule