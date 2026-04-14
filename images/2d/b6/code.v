module fractional_n_pll (  
    input clk_in,  
    input [3:0] control_word,  
    output reg clk_out  
);  
    reg [3:0] divider;  
    reg [3:0] counter;  

    always @(posedge clk_in) begin  
        counter <= counter + 1;  
        if (counter >= divider) begin  
            clk_out <= ~clk_out;  
            counter <= 0;  
        end  
    end  

    always @(control_word) begin  
        divider <= control_word + 1;  
    end  
endmodule