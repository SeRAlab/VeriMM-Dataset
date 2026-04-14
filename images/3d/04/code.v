module rs_encoder(
    input [15:0] data,  // 4 data symbols, each 4 bits
    output [23:0] encoded // 6 symbols, 4 data + 2 parity, each 4 bits
);
    wire [3:0] d0, d1, d2, d3;
    assign d0 = data[3:0];    // First 4 bits
    assign d1 = data[7:4];    // Second 4 bits
    assign d2 = data[11:8];   // Third 4 bits
    assign d3 = data[15:12];  // Fourth 4 bits

    // Simple parity generation (just for illustration)
    assign encoded[3:0] = d0;  // First data symbol
    assign encoded[7:4] = d1;  // Second data symbol
    assign encoded[11:8] = d2; // Third data symbol
    assign encoded[15:12] = d3;// Fourth data symbol
    
    // Simple parity symbols (sum of data mod 16)
    assign encoded[19:16] = (d0 + d1) % 16; // First parity
    assign encoded[23:20] = (d2 + d3) % 16; // Second parity
endmodule