module top_module(
    input data_in_0,
    input data_in_1,
    input select,
    output reg data_out
);always @(*) begin
        if (select == 0) begin
            data_out = data_in_0;
        end else begin
            data_out = data_in_1;
        end
    end

endmodule