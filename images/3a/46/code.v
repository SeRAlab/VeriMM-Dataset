module serializer (  
    input clk,  
    input reset,  
    input start,  
    input [7:0] parallel_in,  
    output reg serial_out,  
    output reg done  
);  
    reg [2:0] bit_count;  
    reg [7:0] data;  

    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            serial_out <= 0;  
            done <= 0;  
            bit_count <= 0;  
            data <= 0;  
        end else begin  
            if (start) begin  
                data <= parallel_in;  
                bit_count <= 7;  
                done <= 0;  
            end else if (bit_count < 8) begin  
                serial_out <= data[bit_count];  
                bit_count <= bit_count - 1;  
                if (bit_count == 0) begin  
                    done <= 1;  
                end  
            end  
        end  
    end  
endmodule