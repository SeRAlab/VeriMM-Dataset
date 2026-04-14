module frequency_divider(  
    input clk,  
    output reg clk_out  
);  
    reg [1:0] count;  

    always @(posedge clk) begin  
        count <= count + 1;  
        if (count == 3) begin  
            clk_out <= ~clk_out;  
            count <= 0;  
        end  
    end  
endmodule