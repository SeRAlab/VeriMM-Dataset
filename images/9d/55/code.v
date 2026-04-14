module mux2to1(
    input wire sel,
    input wire [3:0] data0,
    input wire [3:0] data1,
    output reg [3:0] out
);

always @(*) begin
    if (sel) begin
        out = data1;
    end else begin
        out = data0;
    end
end

endmodule