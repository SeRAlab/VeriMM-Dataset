module top_module(e, s, r, q, qn);input e;        
    input s;        
    input r;        
    output q;       
    output qn;      
   
    wire   s1;      
    wire   r1;      
     
    assign s1 = e & s;
    assign r1 = e & r;   
    assign qn = !(s1 | q) === 1;
    assign q = !(r1 | qn) === 1;endmodule