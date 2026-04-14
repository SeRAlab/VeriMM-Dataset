module rle_encoder #(parameter WIDTH = 8, parameter MAX_RUN = 15)  
(  
    input clk,  
    input reset,  
    input [WIDTH-1:0] data_in,  
    output reg [WIDTH-1:0] run_length,  
    output reg [WIDTH-1:0] value_out,  
    output reg valid  
);  
    reg [WIDTH-1:0] count;  
    reg [WIDTH-1:0] current_value;  
    reg encoding;  

    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            count <= 0;  
            current_value <= 0;  
            run_length <= 0;  
            value_out <= 0;  
            valid <= 0;  
            encoding <= 0;  
        end else begin  
            if (data_in == current_value) begin  
                if (count < MAX_RUN) begin  
                    count <= count + 1;  
                end  
            end else begin  
                if (encoding) begin  
                    run_length <= count;  
                    value_out <= current_value;  
                    valid <= 1;  
                    count <= 1;  
                end else begin  
                    count <= 1;  
                    encoding <= 1;  
                end  
                current_value <= data_in;  
            end  
        end  
    end  
endmodule