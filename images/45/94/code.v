module top_module(
    input clk,
    input reset,
    input d,
    output reg q
);// Power supply signals
    supply1 vdd;
    supply0 gnd;

    always @(posedge clk or negedge reset) begin
        if (reset == 0) begin
            q <= 0;
        end else begin
            q <= d;
        end
    end

endmodule