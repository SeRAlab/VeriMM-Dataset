module run_length_encoder (  
    input clk,  
    input rst,  
    input data,  
    output reg [7:0] length,  
    output reg value,  
    output reg valid  
);  
    reg [7:0] count;  
    reg current_value;  
    reg encoding;  

    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            count <= 0;  
            length <= 0;  
            value <= 0;  
            valid <= 0;  
            encoding <= 0;  
        end else begin  
            if (encoding) begin  
                if (data == current_value) begin  
                    count <= count + 1;  
                end else begin  
                    length <= count;  
                    value <= current_value;  
                    valid <= 1;  
                    current_value <= data;  
                    count <= 1;  
                end  
            end else begin  
                current_value <= data;  
                count <= 1;  
                encoding <= 1;  
            end  
        end  
    end  

    always @(negedge clk) begin  
        if (valid) begin  
            valid <= 0;  
        end  
    end  
endmodule