module eeprom_cell (  
    input wire D,  
    input wire WE,  
    input wire RE,  
    input wire RESET,  
    output reg Q  
);  
  
    always @(posedge RESET or posedge WE) begin  
        if (RESET) begin  
            Q <= 0;  
        end else if (WE) begin  
            Q <= D;  
        end  
    end  
  
    always @(posedge RE) begin  
        if (RE) begin  
            Q <= Q;  
        end  
    end  
endmodule