module dwt_filter_bank (  
    input clk,  
    input reset,  
    input valid,  
    input [7:0] data_in,  
    output reg [7:0] approx_out,  
    output reg [7:0] detail_out  
);  

reg [7:0] data_reg [0:1];  
reg [1:0] count;  

always @(posedge clk or posedge reset) begin  
    if (reset) begin  
        approx_out <= 0;  
        detail_out <= 0;  
        data_reg[0] <= 0;  
        data_reg[1] <= 0;  
        count <= 0;  
    end else if (valid) begin  
        data_reg[count] <= data_in;  
        count <= count + 1;  
        if (count == 1) begin  
            approx_out <= (data_reg[0] + data_reg[1]) >> 1; // Low-pass filter  
            detail_out <= (data_reg[0] - data_reg[1]) >> 1; // High-pass filter  
        end  
    end  
end  
endmodule