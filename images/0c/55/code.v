module dwt_hair_transform (  
    input clk,  
    input rst,  
    input [7:0] signal_in,  
    output reg [3:0] approx_out,  
    output reg [3:0] detail_out  
);  
    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            approx_out <= 0;  
            detail_out <= 0;  
        end else begin  
            approx_out <= (signal_in[7:6] + signal_in[5:4]) >> 1;  
            detail_out <= (signal_in[7:6] - signal_in[5:4]);  
        end  
    end  
endmodule