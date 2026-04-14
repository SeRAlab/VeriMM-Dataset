module RLE_Encoder(  
    input clk,  
    input reset,  
    input start,  
    input bit_in,  
    output reg [7:0] run_length,  
    output reg bit_value,  
    output reg valid_output  
);  

reg [7:0] count;  
reg current_bit;  
reg encoding;  

always @(posedge clk or posedge reset) begin  
    if (reset) begin  
        count <= 0;  
        valid_output <= 0;  
        encoding <= 0;  
    end else begin  
        if (start) begin  
            if (!encoding) begin  
                current_bit <= bit_in;  
                count <= 1;  
                encoding <= 1;  
            end else if (bit_in == current_bit) begin  
                count <= count + 1;  
            end else begin  
                run_length <= count;  
                bit_value <= current_bit;  
                valid_output <= 1;  
                current_bit <= bit_in;  
                count <= 1;  
            end  
        end else if (encoding) begin  
            run_length <= count;  
            bit_value <= current_bit;  
            valid_output <= 1;  
            encoding <= 0;  
        end  
    end  
end  

endmodule