module EEPROM_Cell (  
    input clk,  
    input rst,  
    input [7:0] data_in,  
    input read,  
    input write,  
    input erase,  
    output reg [7:0] data_out  
);  

    reg [7:0] memory;  

    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            memory <= 8'b0;  
            data_out <= 8'b0;  
        end else begin  
            if (erase) begin  
                memory <= 8'b0;  
            end else if (write) begin  
                memory <= data_in;  
            end else if (read) begin  
                data_out <= memory;  
            end  
        end  
    end  
endmodule