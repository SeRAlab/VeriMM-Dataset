module deserializer (  
    input clk,  
    input rst,  
    input serial_in,  
    output reg [7:0] parallel_out  
);  
    reg [2:0] count; // 3-bit counter to count 8 bits  
    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            count <= 0;  
            parallel_out <= 8'b0;  
        end else if (count < 8) begin  
            parallel_out <= {serial_in, parallel_out[7:1]};  
            count <= count + 1;  
        end  
    end  
endmodule