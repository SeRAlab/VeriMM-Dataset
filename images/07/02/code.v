module sr_flip_flop (
    input wire S,
    input wire R,
    input wire clk,
    output reg Q,
    output reg Qn
);

always @(posedge clk or posedge R) begin
    if (R) begin
        Q <= 0;
        Qn <= 1;
    end else if (S) begin
        Q <= 1;
        Qn <= 0;
    end
end

always @(*) begin
    Qn = ~Q;
end

endmodule