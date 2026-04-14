module T_Latch (  
    input wire T,  
    input wire E,  
    output reg Q,  
    output wire Qn  
);  
    assign Qn = ~Q;  

    always @(posedge E) begin  
        if (T)  
            Q <= ~Q;  
    end  
endmodule