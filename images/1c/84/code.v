module simple_md5_hash (
    input wire clk,
    input wire rst,
    input wire [31:0] data_in,
    output reg [127:0] hash_out
);
    reg [127:0] temp_hash;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            temp_hash <= 128'h0;
        end else begin
            // Simple mixing function for demonstration purposes
            temp_hash <= {temp_hash[95:0], temp_hash[127:96]} ^ {data_in, ~data_in, data_in[15:0], data_in[31:16]};
        end
    end

    always @(posedge clk) begin
        hash_out <= temp_hash;
    end
endmodule