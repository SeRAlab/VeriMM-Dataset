module calculator (input [7:0] A, input [7:0] B, input sel, output reg [7:0] result);

always @(*) begin
    if(sel == 0) begin
        result = A + B;
    end else begin
        result = A - B;
    end
end

endmodule