module JK_latch (  
    input J,  
    input K,  
    input clk,  
    output reg Q,  
    output reg Qn  
);  
    always @(posedge clk) begin  
        if (J && ~K) begin  
            Q <= 1;  
        end else if (~J && K) begin  
            Q <= 0;  
        end else if (J && K) begin  
            Q <= ~Q;  
        end  
        Qn <= ~Q;  
    end  
endmodule