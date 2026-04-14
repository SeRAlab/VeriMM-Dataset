module md5_hash(input clk, input reset, input [31:0] data_in, output reg [31:0] hash_out);  
    reg [31:0] temp_hash;  
    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            temp_hash <= 32'h0;  
        end else begin  
            temp_hash <= (temp_hash + data_in) ^ (data_in << 5) ^ (data_in >> 3);  
            hash_out <= temp_hash;  
        end  
    end  
endmodule