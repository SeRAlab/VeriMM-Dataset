module chacha20_state_update(
    input wire [31:0] key,
    input wire [31:0] nonce,
    input wire [31:0] counter,
    output reg [31:0] state
);

    reg [31:0] a, b, c, d;

    always @(key, nonce, counter) begin
        a = key + nonce;
        b = key ^ nonce;
        c = key - counter;
        d = nonce - counter;

        // Perform quarter round operation
        a = a + b; d = d ^ a; d = d >> 16; d = d ^ a; 
        c = c + d; b = b ^ c; b = b >> 12; b = b ^ c; 
        a = a + b; d = d ^ a; d = d >> 8; d = d ^ a; 
        c = c + d; b = b ^ c; b = b >> 7; b = b ^ c; 

        // Output the updated state
        state = a + b + c + d;
    end
endmodule