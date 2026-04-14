module error_correction_arq (  
    input wire clk,  
    input wire rst,  
    input wire data_in,  
    input wire data_valid,  
    output reg error_flag,  
    output reg data_out  
);  

    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            error_flag <= 0;  
            data_out <= 0;  
        end else begin  
            if (data_valid) begin  
                data_out <= data_in;  
                error_flag <= 0;  
            end else begin  
                error_flag <= 1;  
            end  
        end  
    end  
endmodule