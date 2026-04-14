module simple_DES (
    input [63:0] data_in,
    input [63:0] key,
    output reg [63:0] data_out
);
    always @(data_in or key) begin
        // Simple XOR operation for encryption
        data_out = data_in ^ key;
    end
endmodule