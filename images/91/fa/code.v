module top_module(input [7:0] a, b, input [7:0] wa, wb, output reg [7:0] result, output reg [7:0] wresult);always @(*) begin
    if (b == 0) begin
        result = 8'b0;
        wresult = 8'b0;
    end
    else if (a != 0 && b != 0) begin
        result = a / b;
        wresult = wa / wb;
    end
    else begin
        result = 8'hFF;
        wresult = 8'hFF;
    end
end

endmodule