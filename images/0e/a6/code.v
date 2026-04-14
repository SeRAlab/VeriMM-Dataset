module T_latch(  
    input T,  
    input enable,  
    input reset,  
    output reg Q  
);  
    always @(posedge reset or posedge enable) begin  
        if (reset) begin  
            Q <= 0;  
        end else if (enable) begin  
            Q <= T ? ~Q : Q;  
        end  
    end  
endmodule