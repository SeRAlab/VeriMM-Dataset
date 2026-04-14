module sha256_processor (  
    input clk,  
    input reset,  
    input [511:0] data_in,  
    output reg [255:0] hash_out  
);  
    reg [255:0] state;  
    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            state <= 256'b0;  
            hash_out <= 256'b0;  
        end else begin  
            // Simple hash function for demonstration:  
            state <= state + data_in[255:0] ^ data_in[511:256];  
            hash_out <= state;  
        end  
    end  
endmodule