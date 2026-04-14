module serializer_8bit (  
    input wire [7:0] parallel_in,  
    input wire clk,  
    input wire reset,  
    output reg serial_out,  
    output reg done  
);  
    reg [2:0] bit_count;  

    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            bit_count <= 3'b000;  
            serial_out <= 1'b0;  
            done <= 1'b0;  
        end else begin  
            if (bit_count < 3'b100) begin  
                serial_out <= parallel_in[7 - bit_count];  
                bit_count <= bit_count + 1;  
                done <= 1'b0;  
            end else begin  
                done <= 1'b1;  
            end  
        end  
    end  
endmodule