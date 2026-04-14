module Register16bit (
    input clk,
    input rst,
    input enable,
    input [15:0] data_in,
    output reg [15:0] data_out
);
    always @(posedge clk) begin
        if (rst) begin
            data_out <= 16'b0000000000000000;
        end else if (enable) begin
            data_out <= data_in;
        end
    end
endmodule