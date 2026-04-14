module deserializer_16bit (  
    input clk,  
    input reset,  
    input [1:0] data_in,  
    input valid_in,  
    output reg [15:0] data_out,  
    output reg valid_out  
);  
    reg [3:0] bit_count;  
    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            data_out <= 16'b0;  
            bit_count <= 4'b0;  
            valid_out <= 1'b0;  
        end  
        else if (valid_in) begin  
            data_out <= {data_out[13:0], data_in};  
            bit_count <= bit_count + 4'b1;  
            if (bit_count == 4'b1111) begin  
                valid_out <= 1'b1;  
            end  
        end  
    end  
endmodule