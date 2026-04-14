module sram_cell (  
    input wire D,  
    input wire WE,  
    input wire RE,  
    output reg Q  
);  
    always @(posedge WE or posedge RE) begin  
        if (WE)  
            Q <= D;  
        else if (RE)  
            Q <= Q;  
    end  
endmodule