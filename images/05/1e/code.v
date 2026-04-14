module deserializer_32bit (  
    input wire clk,  
    input wire reset,  
    input wire [7:0] serial_in,  
    output reg [31:0] parallel_out,  
    output reg data_ready  
);  
    reg [1:0] count;  
    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            count <= 0;  
            parallel_out <= 0;  
            data_ready <= 0;  
        end else begin  
            if (count < 4) begin  
                parallel_out <= {serial_in, parallel_out[31:8]};  
                count <= count + 1;  
                data_ready <= (count == 3);  
            end  
        end  
    end  
endmodule