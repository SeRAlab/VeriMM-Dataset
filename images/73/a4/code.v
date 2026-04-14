module mux_4to1 (
    input data0,
    input data1,
    input data2,
    input data3,
    input [1:0] select,
    output reg data_out
);

    always @(*) begin
        case (select)
            2'b00: data_out = data0;
            2'b01: data_out = data1;
            2'b10: data_out = data2;
            2'b11: data_out = data3;
        endcase
    end

endmodule