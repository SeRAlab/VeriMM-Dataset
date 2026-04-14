module top_module(a2, a1, a0, r2, r1, r0);input a2, a1, a0;
    
    
    output reg r2, r1, r0;
    
    
    always @(a2, a1, a0) begin
        
        
        r2 <= a2 & ~a1 | a2 & ~a0 | (~a2 & a1 & a0);
        r1 <= ~a1 & a0 | a1 & ~a0;
        r0 <= 0;
    end
    
endmodule