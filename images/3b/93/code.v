module dma_controller(  
    input clk,  
    input rst,  
    input start_ch0,  
    input start_ch1,  
    input stop_ch0,  
    input stop_ch1,  
    input [7:0] data_in,  
    output reg busy_ch0,  
    output reg busy_ch1,  
    output reg [7:0] data_out_ch0,  
    output reg [7:0] data_out_ch1  
);  
    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            busy_ch0 <= 0;  
            busy_ch1 <= 0;  
            data_out_ch0 <= 0;  
            data_out_ch1 <= 0;  
        end else begin  
            if (start_ch0 && !busy_ch0) begin  
                busy_ch0 <= 1;  
                data_out_ch0 <= data_in;  
            end  
            if (stop_ch0 && busy_ch0) begin  
                busy_ch0 <= 0;  
            end  

            if (start_ch1 && !busy_ch1) begin  
                busy_ch1 <= 1;  
                data_out_ch1 <= data_in;  
            end  
            if (stop_ch1 && busy_ch1) begin  
                busy_ch1 <= 0;  
            end  
        end  
    end  
endmodule