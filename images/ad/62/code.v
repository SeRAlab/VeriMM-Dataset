module top_module(
    input CLK,
    input RESET,
    input LOAD,
    input [3:0] LOAD_VAL,
    output reg [3:0] Q
);always @(posedge CLK) begin
        if (RESET) begin
            Q <= 4'b0;
        end else if (LOAD) begin
            Q <= LOAD_VAL;
        end else begin
            Q <= Q + 1;
        end
    end

endmodule