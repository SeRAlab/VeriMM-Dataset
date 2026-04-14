module md5_hash(
    input wire clk,
    input wire reset,
    input wire [31:0] data_in,
    output reg [31:0] hash_out
);
    reg [31:0] temp;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            hash_out <= 32'h00000000;
        end else begin
            temp = hash_out ^ data_in;
            hash_out <= {temp[16:0], temp[31:17]} + (temp & 32'hA0A0A0A0); // simple rotation and mix
        end
    end
endmodule