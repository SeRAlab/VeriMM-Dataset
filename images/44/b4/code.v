module top_module(clk, reset, write, data_input, out);parameter n = 64;

    input clk;
    input reset;
    input write;
    input [n - 1 : 0] data_input;

    output reg [n - 1 : 0] out;

    always @(posedge clk)
        begin
            if(reset)
                out = 0;
            else
            if (write)
                out = data_input;
        end
endmodule