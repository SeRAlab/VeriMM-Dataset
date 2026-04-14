module serializer_32bit(  
    input wire clk,  
    input wire [31:0] parallel_in,  
    output reg serial_out  
);  
    reg [4:0] count; // 5 bits to count from 0 to 31  
     
    always @(posedge clk) begin  
        if (count < 32) begin  
            serial_out <= parallel_in[count];  
            count <= count + 1;  
        end else begin  
            count <= 0; // Reset count after all bits are serialized  
        end  
    end  
endmodule