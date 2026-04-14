module simple_des(
    input wire [63:0] data_in,
    input wire [63:0] key,
    output reg [63:0] data_out,
    input wire clk,
    input wire rst
);
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            data_out <= 64'b0;
        end else begin
            data_out <= (data_in ^ key) ^ {key[31:0], key[63:32]}; // Simple operation
        end
    end
endmodule