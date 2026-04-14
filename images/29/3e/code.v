module serializer_8bit (  
    input clk,  
    input reset,  
    input [7:0] parallel_in,  
    output reg serial_out  
);  
    reg [2:0] bit_count;  
    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            bit_count <= 3'b000;  
            serial_out <= 1'b0;  
        end else begin  
            if (bit_count < 3'b111) begin  
                serial_out <= parallel_in[bit_count];  
                bit_count <= bit_count + 1;  
            end  
        end  
    end  
endmodule