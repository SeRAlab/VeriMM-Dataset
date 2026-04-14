module turbo_encoder(  
    input [1:0] data_in,  
    input clk,  
    input reset,  
    output reg [2:0] encoded_out  
);  

always @(posedge clk or posedge reset) begin  
    if (reset) begin  
        encoded_out <= 3'b000;  
    end else begin  
        // Simple encoding scheme:  
        encoded_out[0] <= data_in[0];  
        encoded_out[1] <= data_in[1];  
        encoded_out[2] <= data_in[0] ^ data_in[1]; // XOR for simple parity bit  
    end  
end  
endmodule