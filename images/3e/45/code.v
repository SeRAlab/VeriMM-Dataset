module simple_md5_hash (  
    input wire clk,  
    input wire reset,  
    input wire [63:0] data_in,  
    output reg [127:0] hash_out  
);  
    reg [63:0] data;  
    reg [127:0] hash;  
    integer i;  

    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            hash <= 128'h0;  
            data <= 64'h0;  
        end else begin  
            data <= data_in;  
            hash = 128'h0;  
            for (i = 0; i < 64; i = i + 1) begin  
                hash[i % 128] <= hash[i % 128] ^ data[i % 64];  
            end  
            hash_out <= hash;  
        end  
    end  
endmodule