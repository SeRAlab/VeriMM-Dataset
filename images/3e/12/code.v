module aes_sbox (
    input [7:0] data_in,
    input clk,
    input rst,
    output reg [7:0] data_out
);
    reg [7:0] sbox [0:255];

    // Initialize S-Box
    initial begin
        // Fill the S-Box with the appropriate values (truncated for brevity)
        sbox[8'h00] = 8'h63; 
        sbox[8'h01] = 8'h7c; 
        sbox[8'h02] = 8'h77; 
        //... (fill in the rest of the S-Box values)
        sbox[8'hff] = 8'h0c; 
    end

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            data_out <= 8'h00;
        end else begin
            data_out <= sbox[data_in];
        end
    end
endmodule