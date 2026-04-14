module eeprom_cell (  
    input wire clk,  
    input wire WE,  
    input wire RE,  
    input wire [7:0] D,  
    output reg [7:0] Q  
);  
    always @(posedge clk) begin  
        if (WE) begin  
            Q <= D;  
        end  
    end  

    always @(posedge clk) begin  
        if (RE) begin  
            // output the stored value  
            // Q is already updated by WE or remains the same if WE is low  
        end  
    end  
endmodule