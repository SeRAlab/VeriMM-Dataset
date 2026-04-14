module mux2to1 (
    input [15:0] data0,
    input [15:0] data1,
    input sel,
    output reg [15:0] data_out
);
    always @(*) begin
        if (sel == 0)
            data_out = data0;
        else
            data_out = data1;
    end
endmodule