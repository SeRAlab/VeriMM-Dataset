module sample_rate_converter(  
    input clk,  
    input rst,  
    input data_in,  
    output reg data_out  
);  
    reg [1:0] counter;  

    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            counter <= 0;  
            data_out <= 0;  
        end else begin  
            counter <= counter + 1;  
            if (counter == 2) begin  
                data_out <= data_in;  
                counter <= 0;  
            end  
        end  
    end  
endmodule