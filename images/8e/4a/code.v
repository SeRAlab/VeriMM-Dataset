module top_module(
    input A,
    input B,
    input S,
    input CLK,
    output reg Y
);always @(posedge CLK) begin
    if (S == 0) begin
        Y <= A;
    end else begin
        Y <= B;
    end
end

endmodule