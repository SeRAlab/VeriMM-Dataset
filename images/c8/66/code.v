module mult_3 (input [3:0] in, input reset, output reg [5:0] out);

always @ (in, reset) begin
    if (reset) begin
        out <= 6'b0;
    end
    else begin
        out <= (in * 3);
    end
end

endmodule