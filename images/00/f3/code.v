module TFlipFlop(  
    input T,  
    input CLK,  
    output reg Q,  
    output Qn  
);  
    assign Qn = ~Q;  

    always @(posedge CLK) begin  
        if (T)  
            Q <= ~Q;  
    end  
endmodule