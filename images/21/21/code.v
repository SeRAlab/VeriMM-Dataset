module serializer (  
    input wire clk,  
    input wire reset,  
    input wire [7:0] parallel_in,  
    output reg serial_out  
);  
    reg [2:0] bit_count;  

    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            bit_count <= 3'd0;  
            serial_out <= 1'b0;  
        end else begin  
            if (bit_count < 3'd8) begin  
                serial_out <= parallel_in[7 - bit_count];  
                bit_count <= bit_count + 1;  
            end  
        end  
    end  
endmodule