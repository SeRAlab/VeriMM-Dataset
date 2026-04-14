module md5_hash(input clk, input [3:0] data_in, output reg [3:0] hash_out);  
    always @(posedge clk) begin  
        hash_out <= data_in ^ 4'b1010;  
    end  
endmodule