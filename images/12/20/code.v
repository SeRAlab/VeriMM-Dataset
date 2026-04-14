module SR_flip_flop (
    input wire S,
    input wire R,
    input wire clk,
    output reg Q,
    output wire Qn
);
    assign Qn = ~Q;

    always @(posedge clk) begin
        if (S && ~R) begin
            Q <= 1;
        end else if (~S && R) begin
            Q <= 0;
        end else if (~S && ~R) begin
            // Hold previous state
            Q <= Q; 
        end else begin
            // Invalid state
            Q <= 0;
        end
    end
endmodule