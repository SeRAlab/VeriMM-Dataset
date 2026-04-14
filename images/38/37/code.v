module JK_latch (  
    input J,  
    input K,  
    input clk,  
    output reg Q,  
    output reg Qn  
);  
    always @(posedge clk) begin  
        if (J == 0 && K == 0) begin  
            // Do nothing, hold the state  
        end else if (J == 0 && K == 1) begin  
            Q <= 0;  
        end else if (J == 1 && K == 0) begin  
            Q <= 1;  
        end else if (J == 1 && K == 1) begin  
            Q <= ~Q;  
        end  
        Qn <= ~Q;  
    end  
endmodule