module deserializer_16bit(  
    input wire clk,  
    input wire rst,  
    input wire serial_in,  
    output reg [15:0] parallel_out,  
    output reg data_valid  
);  
    reg [3:0] bit_count;  

    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            bit_count <= 0;  
            parallel_out <= 0;  
            data_valid <= 0;  
        end else begin  
            if (bit_count < 16) begin  
                parallel_out <= {parallel_out[14:0], serial_in};  
                bit_count <= bit_count + 1;  
            end else begin  
                data_valid <= 1;  
            end  
        end  
    end  
endmodule