module deserializer (  
    input clk,  
    input serial_in,  
    output reg [15:0] parallel_out  
);  
    reg [3:0] bit_count;  

    always @(posedge clk) begin  
        if (bit_count < 16) begin  
            parallel_out <= {parallel_out[14:0], serial_in};  
            bit_count <= bit_count + 1;  
        end  
    end  
endmodule