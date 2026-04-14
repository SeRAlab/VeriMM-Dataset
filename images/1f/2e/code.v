module deserializer (  
    input wire clk,  
    input wire reset,  
    input wire serial_in,  
    output reg [7:0] parallel_out  
);  
    reg [2:0] count;  

    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            count <= 3'd0;  
            parallel_out <= 8'b0;  
        end else if (count < 3'd8) begin  
            parallel_out <= {serial_in, parallel_out[7:1]};  
            count <= count + 1;  
        end  
    end  
endmodule