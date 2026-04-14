module md5_transform (
    input clk,
    input rst,
    input [31:0] data_in,
    output reg [31:0] data_out
);
    reg [31:0] temp;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            temp <= 32'h0;
            data_out <= 32'h0;
        end else begin
            temp <= (temp ^ data_in) + 32'h5A827999; // Simple transformation
            data_out <= temp;
        end
    end
endmodule