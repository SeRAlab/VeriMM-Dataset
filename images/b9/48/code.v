module top_module(rst, data_in, data_out);parameter REG_DATA_WIDTH = 16;
parameter DATA_2_WIDTH = 4; 


input rst;
input [DATA_2_WIDTH-1:0] data_in;


output reg [REG_DATA_WIDTH-1:0] data_out;


always @(*)
begin
    if (!rst)
        data_out = 0;        
    else
        data_out = {{(REG_DATA_WIDTH-DATA_2_WIDTH){data_in[DATA_2_WIDTH-1]}}, data_in};
end

endmodule