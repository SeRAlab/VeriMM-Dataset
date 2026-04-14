module sample_rate_converter (  
    input wire clk,  
    input wire rst,  
    input wire in_valid,  
    input wire [7:0] in_data,  
    output reg out_valid,  
    output reg [7:0] out_data  
);  
    reg [1:0] count; // Counter to track sample rate  
    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            count <= 0;  
            out_valid <= 0;  
        end else if (in_valid) begin  
            count <= count + 1;  
            if (count == 1) begin  
                out_data <= in_data;  
                out_valid <= 1;  
            end else if (count == 2) begin  
                out_valid <= 0;  
                count <= 0;  
            end  
        end  
    end  
endmodule