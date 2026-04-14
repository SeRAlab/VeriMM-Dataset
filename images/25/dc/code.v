module fractional_n_pll (  
    input clk,  
    input [3:0] freq_in,  
    output reg [3:0] freq_out  
);  
    always @(posedge clk) begin  
        freq_out <= (freq_in * 3) >> 1; // Multiply by 1.5  
    end  
endmodule