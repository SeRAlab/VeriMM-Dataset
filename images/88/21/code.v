module top_module(
    input [3:0] in0,
    input [3:0] in1,
    output reg [1:0] out
);always @* begin
        if (in0 == in1) begin
            out = 2'b00;
        end else if (in0 > in1) begin
            out = 2'b01;
        end else begin
            out = 2'b10;
        end
    end

endmodule