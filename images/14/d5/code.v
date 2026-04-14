module turbo_encoder (
    input wire [1:0] data_in,
    input wire clk,
    input wire rst,
    output reg [3:0] encoded_out
);
    
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            encoded_out <= 4'b0000;
        end else begin
            // Simple convolutional encoding
            encoded_out[3] <= data_in[0] ^ data_in[1]; // First output bit
            encoded_out[2] <= data_in[0];             // Second output bit
            encoded_out[1] <= data_in[1];             // Third output bit
            encoded_out[0] <= data_in[0] ^ data_in[1]; // Fourth output bit
        end
    end
endmodule