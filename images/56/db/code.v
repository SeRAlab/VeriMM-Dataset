module top_module(
    input [7:0] A,
    input [7:0] B,
    input OP,
    input RESET,
    output reg [7:0] OUT
);always @(*) begin
    if(RESET) begin
        OUT <= 8'b0;
    end
    else if(OP == 0) begin // addition
        OUT <= A + B;
    end
    else begin // subtraction
        OUT <= A - B;
    end
end

endmodule