module sha256(input clk,  
               input reset,  
               input start,  
               input [511:0] message,  
               output reg [255:0] hash,  
               output reg done);  
  
    reg [511:0] w [0:63];  
    reg [255:0] h [0:7];  
    reg [5:0] round;  
  
    initial begin  
        h[0] = 32'h6a09e667;  
        h[1] = 32'hbb67ae85;  
        h[2] = 32'h3c6ef372;  
        h[3] = 32'ha54ff53a;  
        h[4] = 32'h510e527f;  
        h[5] = 32'h9b05688c;  
        h[6] = 32'h1f83d9ab;  
        h[7] = 32'h5be0cd19;  
        round = 0;  
        done = 0;  
    end  
  
    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            round <= 0;  
            done <= 0;  
        end else if (start) begin  
            // Message scheduling and compression logic here  
            // ... (For simplicity, this part is omitted)  
            // Assume hash is calculated correctly at the end  
            hash <= {h[0], h[1], h[2], h[3], h[4], h[5], h[6], h[7]};  
            done <= 1;  
        end  
    end  
endmodule