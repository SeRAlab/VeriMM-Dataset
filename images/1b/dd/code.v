module simple_des(
    input wire clk,
    input wire rst,
    input wire [63:0] data_in,
    input wire [63:0] key,
    output reg [63:0] data_out
);
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            data_out <= 64'b0;
        end else begin
            data_out <= data_in ^ key; // Simple XOR operation for encryption
        end
    end
endmodule