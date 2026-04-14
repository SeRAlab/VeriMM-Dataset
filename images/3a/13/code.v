module sram_cell (  
    input wire D,  
    input wire WE,  
    input wire RE,  
    output reg Q  
);  
    reg stored_data;  

    always @(posedge WE) begin  
        stored_data <= D;  
    end  

    always @(posedge RE) begin  
        Q <= stored_data;  
    end  
endmodule