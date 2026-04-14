module aes_8bit (
    input clk,
    input rst,
    input [7:0] plaintext,
    input [7:0] key,
    output reg [7:0] ciphertext
);

reg [7:0] s_box [0:255]; // Substitution box
reg [7:0] state;

initial begin
    // Fill the S-box with predefined values (example values)
    s_box[0] = 8'h63; s_box[1] = 8'h7c; s_box[2] = 8'h77; s_box[3] = 8'h7b; 
    // ... fill the rest of the S-box ...
    s_box[255] = 8'h00; // Example end value
end

always @(posedge clk or posedge rst) begin
    if (rst) begin
        ciphertext <= 8'h00;
    end else begin
        // Substitution step
        state <= s_box[plaintext];
        // Permutation step (for simplicity, just a rotation here)
        state <= {state[6:0], state[7]};
        // Mixing step (example: XOR with key)
        ciphertext <= state ^ key;
    end
end

endmodule