module sram_cell (  
    input wire D,  
    input wire WE,  
    input wire RE,  
    output reg Q,  
    output reg READING  
);  
    always @(posedge WE) begin  
        Q <= D;  
        READING <= 0;  
    end  

    always @(posedge RE) begin  
        READING <= 1;  
    end  

endmodule