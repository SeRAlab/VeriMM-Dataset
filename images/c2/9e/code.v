module six_to_one (
    input in0,
    input in1,
    input in2,
    input in3,
    input in4,
    input in5,
    output reg out
);

always @(*) begin
    if (in0) begin
        out = 1;
    end else if (in1) begin
        out = 1;
    end else if (in2) begin
        out = 1;
    end else if (in3) begin
        out = 1;
    end else if (in4) begin
        out = 1;
    end else if (in5) begin
        out = 1;
    end else begin
        out = 0;
    end
end

endmodule