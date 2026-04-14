module sha256_simple (  
    input wire clk,  
    input wire reset,  
    input wire [511:0] message,  
    input wire start,  
    output reg [255:0] hash,  
    output reg ready  
);  
    reg [255:0] state;  
    reg [2:0] count;  

    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            state <= 256'h0;  
            count <= 3'b0;  
            hash <= 256'h0;  
            ready <= 0;  
        end else if (start) begin  
            if (count < 3'd8) begin  
                // Simplified SHA-256 compression function (not a real implementation)  
                state <= state + message[(count*64) +: 64];  
                count <= count + 1;  
            end else begin  
                hash <= state;  
                ready <= 1;  
                count <= 3'b0;  
            end  
        end  
    end  
endmodule