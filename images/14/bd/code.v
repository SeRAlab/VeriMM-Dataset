module T_latch(  
    input T,  
    input E,  
    output reg Q  
);  
    always @(posedge E) begin  
        if (T)  
            Q <= ~Q;  
    end  
endmodule