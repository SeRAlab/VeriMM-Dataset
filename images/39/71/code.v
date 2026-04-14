module hamming_encoder (
    input [15:0] data_in,
    output reg [20:0] encoded_out
);
    integer i;
    reg [20:0] temp;
    
    always @(*) begin
        // Initialize temp with data bits
        temp = {5'b0, data_in}; // Start with 5 leading zeros for parity bits
        
        // Calculate parity bits
        temp[0] = temp[1] ^ temp[2] ^ temp[4] ^ temp[8] ^ temp[16]; // P1
        temp[1] = temp[1] ^ temp[2] ^ temp[5] ^ temp[8] ^ temp[16]; // P2
        temp[3] = temp[3] ^ temp[4] ^ temp[5] ^ temp[8];           // P4
        temp[7] = temp[7] ^ temp[8] ^ temp[9] ^ temp[10];         // P8
        temp[15] = temp[15] ^ temp[16] ^ temp[17] ^ temp[18];     // P16
        
        encoded_out = temp; // Assign encoded output
    end
endmodule