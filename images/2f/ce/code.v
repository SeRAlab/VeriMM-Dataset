module sample_rate_converter (  
    input clk,  
    input rst,  
    input valid_in,  
    input [7:0] data_in,  
    output reg valid_out,  
    output reg [7:0] data_out  
);  

reg [7:0] data_buffer;  
reg [1:0] count;  

always @(posedge clk or posedge rst) begin  
    if (rst) begin  
        valid_out <= 0;  
        count <= 0;  
    end else begin  
        if (valid_in) begin  
            data_buffer <= data_in;  
            count <= 0;  
        end  

        if (count == 1) begin  
            valid_out <= 1;  
            data_out <= data_buffer;  
        end else begin  
            valid_out <= 0;  
        end  

        count <= count + 1;  
    end  
end  
endmodule