module adc_controller (  
    input clk,  
    input rst,  
    input [15:0] adc_data,  
    output reg [15:0] avg_output  
);  
    reg [15:0] buffer [0:7];  
    reg [2:0] index;  
    reg [31:0] sum;  
    reg [3:0] count;  

    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            index <= 3'b000;  
            sum <= 32'b0;  
            count <= 4'b0;  
            avg_output <= 16'b0;  
        end else begin  
            sum <= sum - buffer[index] + adc_data;  
            buffer[index] <= adc_data;  
            index <= (index + 1) % 8;  
            if (count < 8) begin  
                count <= count + 1;  
            end  
            avg_output <= sum / (count + 1);  
        end  
    end  
endmodule