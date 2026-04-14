module top_module(select, ldr_data, result, out_load_data);input select;
    input [31:0] ldr_data, result;
    output reg [31:0] out_load_data;

    always @ *
    begin
        if (select)
            out_load_data = ldr_data;
        else
            out_load_data = result;
    end
endmodule