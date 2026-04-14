module SR_Latch (
    input wire S,
    input wire R,
    output reg Q,
    output reg Qn
);
    always @(posedge S or posedge R) begin
        if (R) begin
            Q <= 0;
            Qn <= 1;
        end else if (S) begin
            Q <= 1;
            Qn <= 0;
        end
    end

    initial begin
        Q = 0;
        Qn = 1;
    end
endmodule