module fir_filter (
    input [2:0] data_in,
    output reg [2:0] data_out
);
    always @(*) begin
        data_out = data_in[2] * 1 + data_in[1] * 0 + data_in[0] * (-1);
    end
endmodule