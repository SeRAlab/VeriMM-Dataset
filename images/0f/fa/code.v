module frequency_divider(  
    input wire clk_in,  
    output reg clk_out  
);  
    reg [1:0] count;  

    always @(posedge clk_in) begin  
        count <= count + 1;  
        if (count == 2'b11) begin  
            clk_out <= ~clk_out;  
            count <= 0;  
        end  
    end  
endmodule