module aes_simple_encryption (
    input wire [3:0] data_in, // 4-bit input data
    input wire [3:0] key,     // 4-bit key
    input wire clk,           // clock signal
    output reg [3:0] data_out // 4-bit output encrypted data
);

always @(posedge clk) begin
    // Simple XOR encryption followed by rotation
    data_out <= {data_in[2:0], data_in[3]} ^ key; // Rotate left and XOR with key
end

endmodule