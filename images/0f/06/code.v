module eeprom_cell (  
    input wire clk,  
    input wire rst,  
    input wire we,  
    input wire [7:0] D,  
    output reg [7:0] Q  
);  
    reg [7:0] stored_data;  

    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            stored_data <= 8'b0;  
            Q <= 8'b0;  
        end else begin  
            if (we) begin  
                stored_data <= D;  
            end  
            Q <= stored_data;  
        end  
    end  
endmodule