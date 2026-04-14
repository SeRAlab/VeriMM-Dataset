module mux_2_to_1 (
    input [3:0] data0,
    input [3:0] data1,
    input sel,
    output reg [3:0] y
);
    always @(*) begin
        if (sel)
            y = data1;
        else
            y = data0;
    end
endmodule