module top_module(
    input [3:0] num1,
    input [3:0] num2,
    output reg [3:0] larger
);always @(*) begin
        if(num1 > num2) begin
            larger = num1;
        end
        else if(num2 > num1) begin
            larger = num2;
        end
        else begin
            larger = num1;
        end
    end

endmodule