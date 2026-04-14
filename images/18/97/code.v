module sram_cell (  
    input wire D,  
    input wire WE,  
    input wire RE,  
    output reg Q  
);  
    always @(*) begin  
        if (WE)  
            Q = D;  
    end  

    always @(*) begin  
        if (RE)  
            Q = Q;  
    end  
endmodule