module top_module(
    input [7:0] a,
    input [7:0] b,
    output reg [7:0] out
);always @* begin
    if(a >= b) begin
        out = a;
    end
    else if(b > a) begin
        out = b;
    end
    else begin
        out = 0;
    end
end

endmodule