module mux_2to1 (
    input data0,
    input data1,
    input select,
    output reg data_out
);

    always @(*) begin
        if (select)
            data_out = data1;
        else
            data_out = data0;
    end

endmodule