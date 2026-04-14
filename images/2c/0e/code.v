module mux_16bit (
    input [15:0] data0,
    input [15:0] data1,
    input select,
    output reg [15:0] out
);
    always @(*) begin
        if (select) 
            out = data1;
        else 
            out = data0;
    end
endmodule