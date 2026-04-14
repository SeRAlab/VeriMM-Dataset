module sample_rate_converter #(parameter N = 4) (  
    input clk,  
    input rst,  
    input data_in,  
    output reg data_out  
);  
    reg [N-1:0] counter;  
    reg data_buffer;  

    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            counter <= 0;  
            data_out <= 0;  
            data_buffer <= 0;  
        end else begin  
            counter <= counter + 1;  
            if (counter == N-1) begin  
                data_out <= data_buffer;  
                counter <= 0;  
            end  
            data_buffer <= data_in;  
        end  
    end  
endmodule