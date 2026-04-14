module AES_8bit (
    input wire clk,
    input wire rst,
    input wire [7:0] data_in,
    input wire [7:0] key,
    output reg [7:0] encrypted_out
);
    
    // S-Box (example values, can be modified for actual AES)
    reg [7:0] S_Box [0:255];
    
    initial begin
        // Fill S-Box with example values (this should be the actual AES S-Box)
        S_Box[8'h00] = 8'h63; S_Box[8'h01] = 8'h7c; S_Box[8'h02] = 8'h77; // ... and so on
        S_Box[8'hff] = 8'h16; // Example end value
    end

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            encrypted_out <= 8'b0;
        end else begin
            encrypted_out <= S_Box[data_in ^ key]; // Simple XOR with key and S-Box lookup
        end
    end
endmodule