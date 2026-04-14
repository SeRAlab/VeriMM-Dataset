module hamming_encoder(  
    input [15:0] data_in,  
    output reg [20:0] code_out  
);  

    wire [3:0] parity;  
    wire [15:0] encoded;  

    assign encoded = {data_in[15:0]};  

    // Calculate parity bits for Hamming code
    assign parity[0] = data_in[0] ^ data_in[1] ^ data_in[3] ^ data_in[4] ^ data_in[6] ^ data_in[8] ^ data_in[10] ^ data_in[12] ^ data_in[14];
    assign parity[1] = data_in[0] ^ data_in[2] ^ data_in[3] ^ data_in[5] ^ data_in[6] ^ data_in[8] ^ data_in[10] ^ data_in[13] ^ data_in[14];
    assign parity[2] = data_in[1] ^ data_in[2] ^ data_in[3] ^ data_in[7] ^ data_in[8] ^ data_in[9] ^ data_in[10] ^ data_in[15];
    assign parity[3] = data_in[4] ^ data_in[5] ^ data_in[6] ^ data_in[7] ^ data_in[8] ^ data_in[9] ^ data_in[10] ^ data_in[11] ^ data_in[12] ^ data_in[13] ^ data_in[14] ^ data_in[15];

    // Combine data and parity bits
    always @(*) begin
        code_out = {parity, encoded};
    end  
endmodule