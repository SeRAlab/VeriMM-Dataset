module JK_latch (  
    input J,  
    input K,  
    input clk,  
    output reg Q,  
    output reg Q_not  
);  
    always @(posedge clk) begin  
        if (J == 0 && K == 0)  
            Q <= Q;  
        else if (J == 1 && K == 0)  
            Q <= 1;  
        else if (J == 0 && K == 1)  
            Q <= 0;  
        else if (J == 1 && K == 1)  
            Q <= ~Q;  
        Q_not <= ~Q;  
    end  
endmodule