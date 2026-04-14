module sha256_simple(input [31:0] data_in,  
                      output reg [31:0] hash_out,  
                      input clk,  
                      input reset);  
  
    reg [31:0] temp;  

    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            hash_out <= 32'b0;  
            temp <= 32'b0;  
        end else begin  
            temp <= (data_in ^ (hash_out + 1));  // Simple transformation  
            hash_out <= temp;  
        end  
    end  
endmodule