module top_module(
    input signed [7:0] A,
    input signed [7:0] B,
    input sel,
    output reg signed [7:0] Y
);always @(*) begin
        if(sel == 0) begin
            Y = A + B;
        end
        else begin
            Y = A - B;
        end
    end

endmodule