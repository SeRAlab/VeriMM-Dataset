module mux_2to1 (
    input [7:0] data0,
    input [7:0] data1,
    input sel,
    output reg [7:0] out
);
    always @(*) begin
        if (sel) 
            out = data1;
        else 
            out = data0;
    end
endmodule