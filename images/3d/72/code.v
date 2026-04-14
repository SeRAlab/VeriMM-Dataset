module sha256_transform (  
    input wire clk,  
    input wire enable,  
    input wire [31:0] data_in,  
    output reg [31:0] data_out  
);  
    reg [31:0] state;  
  
    always @(posedge clk) begin  
        if (enable) begin  
            // A simplified SHA-256 transformation  
            state <= data_in ^ (data_in >> 7) ^ (data_in >> 18) ^ (data_in << 3);  
            data_out <= state;  
        end  
    end  
endmodule