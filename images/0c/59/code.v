module fractional_n_pll #(parameter N=4, M=3) (  
    input clk_ref,  
    input [M-1:0] frac_val,  
    output reg clk_out  
);  
    reg [M-1:0] counter = 0;  
    reg [N-1:0] div_count = 0;  
    reg clk_div;  

    always @(posedge clk_ref) begin  
        if (counter < frac_val) begin  
            clk_div <= 1;  
            counter <= counter + 1;  
        end else begin  
            clk_div <= 0;  
            counter <= 0;  
        end  
    end  

    always @(posedge clk_div) begin  
        div_count <= div_count + 1;  
        if (div_count >= N-1) begin  
            clk_out <= ~clk_out;  
            div_count <= 0;  
        end  
    end  
endmodule