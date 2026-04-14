module aes_8bit (
    input wire clk,
    input wire rst,
    input wire [7:0] plaintext,
    input wire [7:0] key,
    output reg [7:0] ciphertext
);
    reg [7:0] state;

    // S-box for byte substitution
    reg [7:0] S_box [0:255];
    
    initial begin
        // Initialize the S-box (for brevity, only a few entries are filled)
        S_box[0] = 8'h63; S_box[1] = 8'h7c; S_box[2] = 8'h77; // Fill the rest accordingly
        // ... continue filling S_box ...
        S_box[255] = 8'h00; // Last entry
    end

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= 8'h00;
            ciphertext <= 8'h00;
        end else begin
            // Byte substitution
            state <= S_box[plaintext];
            // Row shifting (for 8-bit, it's trivial; we will just keep it as is)
            // Mix columns (simplified for 8 bits)
            ciphertext <= state ^ key; // Just an example operation
        end
    end
endmodule