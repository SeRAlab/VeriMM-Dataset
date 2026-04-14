module top_module(
    input [3:0] num1,
    input [3:0] num2,
    input op,
    input reset,
    output reg [3:0] result
);always @(*) begin
    if(reset) begin
        result <= 4'b0;
    end else if(op) begin
        result <= num1 - num2;
    end else begin
        result <= num1 + num2;
    end
end

endmodule