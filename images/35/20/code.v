module sd_card_controller(  
    input clk,  
    input rst,  
    input read,  
    input write,  
    input [7:0] data_in,  
    output reg [7:0] data_out,  
    output reg busy  
);  
    reg [7:0] memory;  // Simple memory to store data  

    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            busy <= 0;  
            data_out <= 8'b0;  
            memory <= 8'b0;  
        end else begin  
            if (read) begin  
                busy <= 1;  
                data_out <= memory;  
            end else if (write) begin  
                busy <= 1;  
                memory <= data_in;  
            end else begin  
                busy <= 0;  
            end  
        end  
    end  
endmodule