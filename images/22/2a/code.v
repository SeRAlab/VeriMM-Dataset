module deserializer (  
    input clk,  
    input reset,  
    input serial_in,  
    output reg [7:0] parallel_out  
);  
    reg [2:0] bit_count;  
    
    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            parallel_out <= 8'b0;  
            bit_count <= 3'b0;  
        end else if (bit_count < 3'd8) begin  
            parallel_out <= {parallel_out[6:0], serial_in};  
            bit_count <= bit_count + 1;  
        end  
    end  
endmodule