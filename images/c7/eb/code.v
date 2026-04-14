module and_module (
    input A,
    input B,
    input CLK,
    output reg X
);

    always @(posedge CLK) begin
        X <= A & B;
    end

endmodule