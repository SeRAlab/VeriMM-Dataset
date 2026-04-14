module fractional_n_pll(  
    input clk_ref,  
    input [7:0] frac_div,  
    output reg clk_out  
);  
    reg [7:0] counter;  
    reg [7:0] divider;  
    reg state;  

    always @(posedge clk_ref) begin  
        if (state) begin  
            if (counter < frac_div) begin  
                clk_out <= 1;  
                counter <= counter + 1;  
            end else begin  
                clk_out <= 0;  
                counter <= 0;  
                state <= 0;  
            end  
        end else begin  
            if (counter < (256 - frac_div)) begin  
                clk_out <= 0;  
                counter <= counter + 1;  
            end else begin  
                state <= 1;  
                counter <= 0;  
            end  
        end  
    end  
endmodule