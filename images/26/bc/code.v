module mux_2_to_1 (
    input [3:0] data0,
    input [3:0] data1,
    input select,
    output reg [3:0] out
);
    always @(*) begin
        if (select)
            out = data1;
        else
            out = data0;
    end
endmodule