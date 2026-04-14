module FlashMemoryCell (  
    input wire D,  
    input wire WE,  
    input wire RST,  
    output reg Q  
);  
    always @(posedge WE or posedge RST) begin  
        if (RST)  
            Q <= 0;  
        else  
            Q <= D;  
    end  
endmodule