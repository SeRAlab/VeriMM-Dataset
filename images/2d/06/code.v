module deserializer(  
    input wire clk,  
    input wire serial_in,  
    output reg [7:0] parallel_out,  
    output reg data_valid  
);  
    reg [2:0] bit_count;  
    
    always @(posedge clk) begin  
        if (bit_count < 8) begin  
            parallel_out <= {parallel_out[6:0], serial_in};  
            bit_count <= bit_count + 1;  
        end  
        if (bit_count == 7) begin  
            data_valid <= 1;  
        end else begin  
            data_valid <= 0;  
        end  
    end  
endmodule