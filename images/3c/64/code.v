module sha256_simple (  
    input clk,  
    input reset,  
    input [31:0] data_in,  
    output reg [31:0] hash_out,  
    input start,  
    output reg done  
);  
    reg [31:0] h [0:7];  
    reg [3:0] state;  

    initial begin  
        h[0] = 32'h6a09e667;  
        h[1] = 32'hbb67ae85;  
        h[2] = 32'h3c6ef372;  
        h[3] = 32'ha54ff53a;  
        h[4] = 32'h510e527f;  
        h[5] = 32'h9b05688c;  
        h[6] = 32'h1f83d9ab;  
        h[7] = 32'h5be0cd19;  
        state = 0;  
        done = 0;  
    end  

    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            h[0] <= 32'h6a09e667;  
            h[1] <= 32'hbb67ae85;  
            h[2] <= 32'h3c6ef372;  
            h[3] <= 32'ha54ff53a;  
            h[4] <= 32'h510e527f;  
            h[5] <= 32'h9b05688c;  
            h[6] <= 32'h1f83d9ab;  
            h[7] <= 32'h5be0cd19;  
            state <= 0;  
            done <= 0;  
        end else if (start && !done) begin  
            // Simplified example hash calculation  
            h[0] <= h[0] + data_in;  
            h[1] <= h[1] + (data_in >> 1);  
            h[2] <= h[2] + (data_in >> 2);  
            h[3] <= h[3] + (data_in >> 3);  
            h[4] <= h[4] + (data_in >> 4);  
            h[5] <= h[5] + (data_in >> 5);  
            h[6] <= h[6] + (data_in >> 6);  
            h[7] <= h[7] + (data_in >> 7);  
            hash_out <= h[0];  
            done <= 1;  
            state <= state + 1;  
        end  
    end  
endmodule