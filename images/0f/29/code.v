module rle_encoder (  
    input clk,  
    input reset,  
    input data_in,  
    output reg [3:0] count,  
    output reg data_out,  
    output reg valid  
);  
    reg [3:0] cnt;  
    reg current_bit;  

    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            cnt <= 0;  
            count <= 0;  
            data_out <= 0;  
            valid <= 0;  
            current_bit <= 0;  
        end else begin  
            if (data_in == current_bit) begin  
                if (cnt < 15) begin  
                    cnt <= cnt + 1;  
                end  
            end else begin  
                current_bit <= data_in;  
                count <= cnt;  
                data_out <= current_bit;  
                valid <= 1;  
                cnt <= 1;  
            end  
        end  
    end  
endmodule