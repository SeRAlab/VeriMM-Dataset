module top_module(
    input data_0,
    input data_1,
    input enable,
    output reg out
);always @ (data_0, data_1, enable)
    begin
        if (enable)
            out = data_0;
        else
            out = data_1;
    end

endmodule