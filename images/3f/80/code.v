module sr_flip_flop (
    input wire S,
    input wire R,
    input wire clk,
    input wire reset,
    output reg Q,
    output reg Qn
);
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            Q <= 0;
            Qn <= 1;
        end else begin
            if (S && !R) begin
                Q <= 1;
                Qn <= 0;
            end else if (!S && R) begin
                Q <= 0;
                Qn <= 1;
            end
        end
    end
endmodule