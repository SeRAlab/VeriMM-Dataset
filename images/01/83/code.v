module fractional_n_pll (  
    input wire clk_ref,  
    input wire [7:0] numerator,  
    input wire [7:0] denominator,  
    output reg clk_out  
);  
    reg [15:0] counter;  
    reg [15:0] fractional_accumulator;  
    reg [15:0] threshold;  

    initial begin  
        counter = 0;  
        fractional_accumulator = 0;  
        clk_out = 0;  
        threshold = 0;  
    end  

    always @(posedge clk_ref) begin  
        threshold <= numerator * (1 << 8) / denominator;  
        fractional_accumulator <= fractional_accumulator + numerator;  
        if (fractional_accumulator >= threshold) begin  
            clk_out <= ~clk_out;  
            fractional_accumulator <= fractional_accumulator - threshold;  
        end  
    end  
endmodule