module chacha20_key_schedule (
    input wire clk,
    input wire rst,
    input wire [255:0] key,
    input wire [63:0] nonce,
    output reg [255:0] state
);
    reg [255:0] constant;
    
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= 256'b0;
        end else begin
            // Initialize constant and state based on ChaCha20 specification
            constant <= 256'h61707865_3320646e_79622d32_6b206574; // "expand 32-byte k"
            state <= {constant, key, nonce, 32'b0}; // Appending zero counter
        end
    end
endmodule