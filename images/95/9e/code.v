module top_module(
    input [3:0] binary_in,
    input gray_ctrl,
    input rst_n,
    output reg [3:0] gray_out
);reg [3:0] binary_reg1, binary_reg2;
reg [3:0] gray_reg1, gray_reg2;

always @(posedge gray_ctrl or negedge rst_n) begin
    if (~rst_n) begin
        binary_reg1 <= 4'b0000;
        binary_reg2 <= 4'b0000;
        gray_reg1 <= 4'b0000;
        gray_reg2 <= 4'b0000;
    end else begin
        binary_reg1 <= binary_in;
        binary_reg2 <= binary_reg1;
        gray_reg1 <= gray_out;
        gray_reg2 <= gray_reg1;
    end
end

always @(posedge gray_ctrl or negedge rst_n) begin
    if (~rst_n) begin
        gray_out <= 4'b0000;
    end else begin
        if (gray_ctrl == 1'b0) begin
            gray_out <= binary_reg1 ^ binary_reg2;
        end else begin
            gray_out <= gray_reg1 ^ (gray_reg2 >> 1);
        end
    end
end

endmodule