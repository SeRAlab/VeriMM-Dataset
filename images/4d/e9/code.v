module top_module(
    input [3:0] A,
    input [3:0] B,
    input C,
    output reg [3:0] out
);reg [3:0] sum1, sum2;

always @ (posedge C) begin
    sum1 <= A - B;
end

always @ (posedge C) begin
    sum2 <= A + B;
end

always @ (posedge C) begin
    if (C == 1'b0) begin
        out <= sum2;
    end else begin
        out <= sum1;
    end
end

endmodule