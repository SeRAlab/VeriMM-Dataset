module top_module(clk, rst, data_in, data_out);input clk, rst;
    input [31:0] data_in;
    output reg [31:0] data_out;

    always @(posedge clk or posedge rst)
    begin
        if(rst)
        begin
            data_out <= 0;
        end
        else
        begin
            data_out <= data_in;
        end
    end
endmodule