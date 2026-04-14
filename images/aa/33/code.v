module top_module(
    input A,
    input B,
    input SEL,
    input CLK,
    input RST,
    output reg OUT
);always @(posedge CLK) begin
    if (RST) begin
        OUT <= 0;
    end else begin
        if (SEL) begin
            OUT <= B;
        end else begin
            OUT <= A;
        end
    end
end

endmodule