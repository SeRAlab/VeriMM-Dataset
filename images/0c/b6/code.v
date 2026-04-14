module md5_hash(
    input wire clk,
    input wire reset,
    input wire [127:0] data_in,
    output reg [31:0] hash_out
);
    reg [127:0] temp_data;
    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            hash_out <= 32'b0;
            temp_data <= 128'b0;
        end else begin
            temp_data <= data_in;
            hash_out <= (temp_data[31:0] ^ temp_data[63:32] ^ temp_data[95:64] ^ temp_data[127:96]) + (hash_out + 1);
        end
    end
endmodule