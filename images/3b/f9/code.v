module divide_by_4 (  
    input clk,  
    input rst,  
    input [7:0] in_data,  
    output reg [1:0] out_data  
);  
    reg [7:0] counter;  
    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            counter <= 0;  
            out_data <= 0;  
        end else begin  
            counter <= counter + 1;  
            if (counter == 4) begin  
                out_data <= in_data[3:2]; // Take the upper 2 bits (divide by 4)  
                counter <= 0;  
            end  
        end  
    end  
endmodule