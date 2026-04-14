module D_latch(  
    input D,  
    input E,  
    output reg Q,  
    output reg Qn  
);  
    always @ (D or E) begin  
        if (E) begin  
            Q <= D;  
        end  
        Qn <= ~Q;  
    end  
endmodule