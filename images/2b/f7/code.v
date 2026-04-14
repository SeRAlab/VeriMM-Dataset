module sha256_stage (  
    input wire clk,  
    input wire [511:0] data_in,  
    output reg [31:0] hash_out  
);  
  
    reg [31:0] h0, h1, h2, h3, h4, h5, h6, h7;  
    reg [511:0] message_schedule [0:63];  
    integer i;  
  
    // Initial hash values  
    initial begin  
        h0 = 32'h6a09e667;  
        h1 = 32'hbb67ae85;  
        h2 = 32'h3c6ef372;  
        h3 = 32'ha54ff53a;  
        h4 = 32'h510e527f;  
        h5 = 32'h9b05688c;  
        h6 = 32'h1f83d9ab;  
        h7 = 32'h5be0cd19;  
    end  
  
    always @(posedge clk) begin  
        // Message schedule initialization  
        message_schedule[0] = data_in;  
        
        // Dummy processing for the hash stage  
        for (i = 0; i < 64; i = i + 1) begin  
            hash_out <= h0 + h1 + h2 + h3 + h4 + h5 + h6 + h7;  
        end  
    end  
endmodule