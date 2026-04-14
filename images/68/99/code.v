module mux_2to1(
    input        enable,
    input        sel,
    input  [7:0] data0,
    input  [7:0] data1,
    output reg [7:0] data_out
);

// Multiplexer logic
always @(*) begin
    if (enable) begin
        if (sel)
            data_out = data1;
        else
            data_out = data0;
    end else
        data_out = 8'h00;
end

endmodule