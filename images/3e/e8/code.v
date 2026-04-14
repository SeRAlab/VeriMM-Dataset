module sha256_simple (  
    input clk,  
    input rst,  
    input [31:0] data,  
    input start,  
    output reg [31:0] hash,  
    output reg done  
);  

    reg [31:0] hash_init;  
    reg [31:0] temp;  
    reg state;  

    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            hash <= 32'h0;  
            done <= 0;  
            state <= 0;  
        end else if (start) begin  
            hash_init <= 32'h6a09e667;  // Initial hash value  
            temp <= hash_init ^ data;    // Simple operation for demo  
            hash <= temp + 32'h5bf037e;  // Another simple operation  
            done <= 1;  
            state <= 1;  
        end else if (state) begin  
            done <= 0;  
            state <= 0;  
        end  
    end  
endmodule