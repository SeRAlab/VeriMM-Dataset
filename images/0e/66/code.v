module sample_rate_converter(  
    input clk,  
    input [3:0] sample_rate_in,  
    output reg [1:0] sample_rate_out  
);  
    always @(posedge clk) begin  
        // Downsample the 4-bit input to a 2-bit output  
        sample_rate_out <= sample_rate_in[1:0];  
    end  
endmodule