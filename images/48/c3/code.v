module top_module(
    input clk,
    input UP,
    input DOWN,
    input LOAD,
    input [3:0] DIN,
    output reg [3:0] Q
);always @(posedge clk) begin
        if (LOAD) begin
            Q <= DIN;
        end else if (UP) begin
            if (Q == 4'b1111) begin
                Q <= 4'b0000;
            end else begin
                Q <= Q + 1;
            end
        end else if (DOWN) begin
            if (Q == 4'b0000) begin
                Q <= 4'b1111;
            end else begin
                Q <= Q - 1;
            end
        end
    end

endmodule