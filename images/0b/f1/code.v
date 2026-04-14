module D_latch (input D, input EN, output reg Q);  
    always @ (EN or D) begin  
        if (EN)  
            Q <= D;  
    end  
endmodule