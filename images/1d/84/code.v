module aes_encryption (
    input wire clk,
    input wire [3:0] data_in,
    input wire [3:0] key,
    output reg [3:0] data_out
);
    always @(posedge clk) begin
        data_out <= data_in ^ key; // Simple XOR encryption
    end
endmodule