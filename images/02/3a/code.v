module divide_by_4 (  
    input clk,  
    input [7:0] in_data,  
    output reg [1:0] out_data  
);  
    reg [7:0] count;  
   
    always @(posedge clk) begin  
        count <= count + in_data;  
        out_data <= count[3:2];  
    end  
endmodule