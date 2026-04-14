module fractional_n_pll (  
    input wire clk_ref,  
    input wire reset,  
    input wire [3:0] fractional_value,  
    output reg clk_out  
);  
    reg [3:0] counter;  
    reg clk_div;  
    reg [3:0] division_factor;  

    always @(posedge clk_ref or posedge reset) begin  
        if (reset) begin  
            counter <= 0;  
            clk_out <= 0;  
            division_factor <= fractional_value;  
        end else begin  
            if (counter < division_factor) begin  
                counter <= counter + 1;  
            end else begin  
                clk_out <= ~clk_out;  
                counter <= 0;  
            end  
        end  
    end  
endmodule