module my_module (
    clk,
    rst,
    data_in,
    enable,
    data_out
);

    input clk, rst, enable;
    input [3:0] data_in;
    output reg [3:0] data_out;

    always @(posedge clk) begin
        if (rst) begin
            data_out <= 4'b0;
        end
        else if (enable) begin
            data_out <= data_in;
        end
    end

endmodule