module aes_sbox (
    input [7:0] data_in,
    output reg [7:0] data_out,
    input clk,
    input rst
);
    
    // S-Box Lookup Table
    reg [7:0] sbox [0:255];
    
    initial begin
        // Initialize S-Box (values are from the AES standards)
        sbox[8'h00] = 8'h63; sbox[8'h01] = 8'h7c; sbox[8'h02] = 8'h77; 
        sbox[8'h03] = 8'h7b; sbox[8'h04] = 8'hf2; sbox[8'h05] = 8'h6b; 
        sbox[8'h06] = 8'h6f; sbox[8'h07] = 8'hc5; sbox[8'h08] = 8'h30; 
        sbox[8'h09] = 8'h01; sbox[8'h0a] = 8'h67; sbox[8'h0b] = 8'h2b; 
        sbox[8'h0c] = 8'hfe; sbox[8'h0d] = 8'hd7; sbox[8'h0e] = 8'hab; 
        sbox[8'h0f] = 8'h76; /* ... (complete initialization with all 256 entries) ... */
        sbox[8'hff] = 8'h16; 
    end

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            data_out <= 8'b0;
        end else begin
            data_out <= sbox[data_in];
        end
    end
endmodule