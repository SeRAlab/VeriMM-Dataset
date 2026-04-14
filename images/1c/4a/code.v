module sample_rate_converter(  
    input clk,  
    input reset,  
    output reg output_signal  
);  
    reg [1:0] count;  

    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            count <= 0;  
            output_signal <= 0;  
        end else begin  
            count <= count + 1;  
            if (count == 1) begin  
                output_signal <= 1;  
            end else if (count == 2) begin  
                output_signal <= 0;  
                count <= 0;  
            end  
        end  
    end  
endmodule