module hamming_encoder (  
    input [7:0] data_in,  
    output reg [11:0] encoded_out  
);  
    always @(*) begin  
        encoded_out[2:0] = {1'b0, data_in[6], data_in[5]};  // P1  
        encoded_out[4:3] = {1'b0, data_in[7]};              // P2  
        encoded_out[6:5] = {1'b0, data_in[4]};              // P3  
        encoded_out[11:7] = data_in;                        // D1-D8  
        // Calculate parity bits  
        encoded_out[0] = data_in[0] ^ data_in[1] ^ data_in[3] ^ data_in[4] ^ data_in[6]; // P1  
        encoded_out[1] = data_in[0] ^ data_in[2] ^ data_in[3] ^ data_in[5] ^ data_in[6]; // P2  
        encoded_out[3] = data_in[1] ^ data_in[2] ^ data_in[3] ^ data_in[5] ^ data_in[7]; // P3  
        encoded_out[10] = data_in[0] ^ data_in[1] ^ data_in[2] ^ data_in[7]; // P4  
    end  
endmodule