module sr_flip_flop (
    input wire S,
    input wire R,
    input wire clk,
    output reg Q,
    output reg Qn
);
    always @(posedge clk or posedge S or posedge R) begin
        if (S) begin
            Q <= 1'b1;
            Qn <= 1'b0;
        end else if (R) begin
            Q <= 1'b0;
            Qn <= 1'b1;
        end
    end

    // Ensure Qn is always the inverse of Q
    always @(*) begin
        Qn = ~Q;
    end
endmodule