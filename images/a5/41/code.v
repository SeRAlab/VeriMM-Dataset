module top_module(
    input wire C,
    input wire D,
    input wire PRE,
    output reg Q
);parameter INIT = 0;
    localparam FLOP_DELAY = 100;

    initial Q = INIT;

    always @(posedge C) begin
        if (PRE) begin
            Q <= 1'b1;
        end else begin
            #FLOP_DELAY Q <= D;
        end
    end

endmodule