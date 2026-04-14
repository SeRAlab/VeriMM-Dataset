module top_module(
    input CLK,
    input RST,
    output reg Q1,
    output reg Q0
);always @(posedge CLK) begin
    if (RST) begin
        Q1 <= 0;
        Q0 <= 0;
    end else if (Q1 == 1 && Q0 == 1) begin
        Q1 <= 0;
        Q0 <= 0;
    end else if (Q0 == 1) begin
        Q1 <= 1;
        Q0 <= 0;
    end else begin
        Q1 <= 0;
        Q0 <= 1;
    end
end

endmodule