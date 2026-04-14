module fractional_n_pll (  
    input wire clk,  
    input wire [2:0] control_word,  
    output reg [7:0] output_freq  
);  
    always @(posedge clk) begin  
        output_freq <= control_word * 8; // Multiply by a fixed factor of 8  
    end  
endmodule