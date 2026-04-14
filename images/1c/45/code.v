module frequency_divider(  
    input clk_in,  
    output reg clk_out  
);  
    reg [1:0] counter;  

    always @(posedge clk_in) begin  
        counter <= counter + 1;  
        if (counter == 2'b11) begin  
            clk_out <= ~clk_out;  
        end  
    end  
endmodule