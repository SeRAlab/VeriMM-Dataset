module deserializer_8bit (  
    input clk,  
    input reset,  
    input serial_in,  
    output reg [7:0] parallel_out,  
    output reg valid  
);  
    reg [2:0] bit_count;  
    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            parallel_out <= 8'b0;  
            valid <= 0;  
            bit_count <= 3'b0;  
        end else begin  
            if (bit_count < 8) begin  
                parallel_out[bit_count] <= serial_in;  
                bit_count <= bit_count + 1;  
            end  
            if (bit_count == 7) begin  
                valid <= 1;  
            end else if (bit_count == 8) begin  
                valid <= 0;  
                bit_count <= 0;  
            end  
        end  
    end  
endmodule