module mux_2to1_enable(
    input data_in_0,
    input data_in_1,
    input enable,
    output reg data_out
);

always @(*) begin
    if(enable == 1'b0) begin
        data_out = data_in_0;
    end
    else begin
        data_out = data_in_1;
    end
end

endmodule