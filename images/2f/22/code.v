module md5_hash(input clk, input [3:0] data_in, output reg [3:0] hash_out);  
    reg [3:0] state;  
    
    always @(posedge clk) begin  
        state <= (data_in << 1) ^ (data_in >> 1);  
    end  
    
    always @(posedge clk) begin  
        hash_out <= state;  
    end  
endmodule