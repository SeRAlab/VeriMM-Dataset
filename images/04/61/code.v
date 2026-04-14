module sr_flip_flop (
    input wire S,
    input wire R,
    input wire clk,
    output reg Q,
    output reg Qn
);

always @(posedge clk or posedge S or posedge R) begin
    if (S) begin
        Q <= 1;
        Qn <= 0;
    end else if (R) begin
        Q <= 0;
        Qn <= 1;
    end
    // hold state when both S and R are 0
end

endmodule