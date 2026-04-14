module md5_transform (
    input clk,
    input rst_n,
    input [31:0] data_in,
    output reg [31:0] data_out
);

    reg [31:0] temp;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            data_out <= 32'b0;
        end else begin
            temp <= data_in + 32'h5A827999; // Simple transformation
            data_out <= {temp[23:0], temp[31:24]}; // Rotate left by 8
        end
    end
endmodule