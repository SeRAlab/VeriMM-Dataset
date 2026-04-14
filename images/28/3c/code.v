module md5_transform(  
    input clk,  
    input rst,  
    input [127:0] data_in,  
    output reg [127:0] data_out  
);  
    reg [127:0] state;  
  
    always @(posedge clk or posedge rst) begin  
        if (rst)  
            state <= 128'h0;  
        else  
            state <= (state + data_in) ^ (state << 7) ^ (state >> 3);  
    end  
  
    always @(posedge clk) begin  
        data_out <= state;  
    end  
endmodule