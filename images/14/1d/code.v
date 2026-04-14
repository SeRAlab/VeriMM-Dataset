module deserializer_16bit (  
    input wire clk,  
    input wire serial_in,  
    output reg [15:0] parallel_out,  
    output reg valid  
);  
    reg [3:0] count;  

    always @(posedge clk) begin  
        if (count < 16) begin  
            parallel_out[count] <= serial_in;  
            count <= count + 1;  
        end  
        if (count == 15) begin  
            valid <= 1;  
        end else if (count == 16) begin  
            valid <= 0;  
            count <= 0;  
        end  
    end  
endmodule