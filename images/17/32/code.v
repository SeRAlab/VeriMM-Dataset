module divide_by_4(  
    input clk,  
    input rst,  
    output reg [1:0] out  
);  
    reg [3:0] counter;  
    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            counter <= 0;  
            out <= 0;  
        end else begin  
            counter <= counter + 1;  
            out <= counter[3:2]; // Output the 2 MSBs to represent divided value  
        end  
    end  
endmodule