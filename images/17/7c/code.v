module InterruptController (  
    input wire RST,  
    input wire IRQ0,  
    input wire IRQ1,  
    input wire IRQ2,  
    output reg IRQ_OUT  
);  
    always @(posedge RST or posedge IRQ0 or posedge IRQ1 or posedge IRQ2) begin  
        if (RST) begin  
            IRQ_OUT <= 0;  
        end else if (IRQ0) begin  
            IRQ_OUT <= 1; // IRQ0 has highest priority  
        end else if (IRQ1) begin  
            IRQ_OUT <= 2; // IRQ1 has medium priority  
        end else if (IRQ2) begin  
            IRQ_OUT <= 3; // IRQ2 has lowest priority  
        end  
    end  
endmodule