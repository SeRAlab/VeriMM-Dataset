module deserializer_32bit (  
    input wire clk,  
    input wire reset,  
    input wire serial_in,  
    output reg [31:0] parallel_out,  
    output reg valid  
);  
    reg [4:0] count; // 5 bits to count up to 32  
    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            count <= 0;  
            parallel_out <= 0;  
            valid <= 0;  
        end else begin  
            if (count < 32) begin  
                parallel_out[count] <= serial_in;  
                count <= count + 1;  
            end  
            if (count == 31) begin  
                valid <= 1;  
            end  
        end  
    end  
endmodule