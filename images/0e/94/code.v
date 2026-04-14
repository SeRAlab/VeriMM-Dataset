module mux_2to1 (
    input [15:0] data0,
    input [15:0] data1,
    input sel,
    output reg [15:0] mux_out
);
    always @(*) begin
        if (sel) 
            mux_out = data1;
        else 
            mux_out = data0;
    end
endmodule