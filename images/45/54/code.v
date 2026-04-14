module top_module (
    input select,
    input [3:0] data0,
    input [3:0] data1,
    output reg [3:0] data_out);always @(*) begin
        if (select)
            data_out = data1;
        else
            data_out = data0;
    end
    
endmodule