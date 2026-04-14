module fractional_n_pll(  
    input wire clk_ref,  
    input wire [7:0] numerator,  
    input wire [7:0] denominator,  
    output reg clk_out  
);  
    reg [15:0] counter;  
    reg [15:0] target_count;  

    always @(posedge clk_ref) begin  
        if (denominator != 0)  
            target_count <= numerator * (16'hFFFF / denominator);  
        else  
            target_count <= 0;  
        
        if (counter >= target_count) begin  
            clk_out <= ~clk_out;  
            counter <= 0;  
        end else begin  
            counter <= counter + 1;  
        end  
    end  
endmodule