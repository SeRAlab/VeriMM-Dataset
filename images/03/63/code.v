module serializer_8bit (  
    input wire clk,  
    input wire reset,  
    input wire [7:0] parallel_in,  
    input wire valid,  
    output reg serial_out  
);  
    reg [2:0] bit_counter;  
    
    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            serial_out <= 0;  
            bit_counter <= 0;  
        end else if (valid) begin  
            if (bit_counter < 8) begin  
                serial_out <= parallel_in[bit_counter];  
                bit_counter <= bit_counter + 1;  
            end else begin  
                bit_counter <= 0;  
            end  
        end  
    end  
endmodule