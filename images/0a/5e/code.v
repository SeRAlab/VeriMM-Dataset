module deserializer (  
    input wire clk,  
    input wire serial_in,  
    output reg [7:0] parallel_out  
);  
    reg [2:0] count;  
    always @(posedge clk) begin  
        if (count < 8) begin  
            parallel_out[count] <= serial_in;  
            count <= count + 1;  
        end  
    end  
    initial begin  
        count = 0;  
        parallel_out = 8'b0;  
    end  
endmodule