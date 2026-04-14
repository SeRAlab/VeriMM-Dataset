module serializer (  
    input clk,  
    input reset,  
    input [7:0] parallel_in,  
    output reg serial_out  
);  
    reg [2:0] count; // Counter for 8 bits  
    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            count <= 0;  
            serial_out <= 0;  
        end else if (count < 8) begin  
            serial_out <= parallel_in[7 - count];  
            count <= count + 1;  
        end else begin  
            serial_out <= 0; // After sending 8 bits, output 0  
        end  
    end  
endmodule