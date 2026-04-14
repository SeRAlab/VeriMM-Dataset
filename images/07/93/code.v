module jk_latch (  
    input J,  
    input K,  
    input CLK,  
    output reg Q,  
    output reg QN  
);  
    initial begin  
        Q = 0;  
        QN = 1;  
    end  
  
    always @(posedge CLK) begin  
        if (J == 1 && K == 0) begin  
            Q <= 1;  
        end else if (J == 0 && K == 1) begin  
            Q <= 0;  
        end else if (J == 1 && K == 1) begin  
            Q <= ~Q;  
        end  
        QN <= ~Q;  
    end  
endmodule