module top_module(
    input CLK,
    input LOAD,
    input [2:0] LOAD_VAL,
    input UP_DOWN,
    input CARRY_IN,
    output reg [2:0] Q
);always @(posedge CLK) begin
        if (LOAD) begin
            Q <= LOAD_VAL;
        end else begin
            if (UP_DOWN) begin
                Q <= Q + 1 + CARRY_IN;
            end else begin
                Q <= Q - 1 - CARRY_IN;
            end
        end
    end

endmodule