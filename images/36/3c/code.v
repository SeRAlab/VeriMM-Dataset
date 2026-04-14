module aes_encrypt (
    input wire clk,
    input wire rst,
    input wire [7:0] data_in,
    input wire [7:0] key,
    output reg [7:0] data_out
);
    
    // Simple S-box for AES
    reg [7:0] s_box [0:255];
    initial begin
        // Populate the S-box with predefined values (for example purposes)
        s_box[8'h00] = 8'h63; s_box[8'h01] = 8'h7c; s_box[8'h02] = 8'h77; //... fill in the rest
        s_box[8'hff] = 8'h00; // last entry
    end

    reg [7:0] permuted_data;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            data_out <= 8'b0;
        end else begin
            // Substitute using S-box
            permuted_data <= s_box[data_in ^ key]; // XOR input with key and substitute
            // Output the permuted data
            data_out <= permuted_data;
        end
    end
endmodule