module sr_flip_flop (
    input wire S,
    input wire R,
    input wire clk,
    input wire reset,
    output reg Q,
    output wire Q_n
);
    assign Q_n = ~Q;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            Q <= 1'b0;
        end else begin
            if (S)
                Q <= 1'b1;
            else if (R)
                Q <= 1'b0;
        end
    end
endmodule