module top_module(
    input CLK,
    input UP,
    input DOWN,
    input RST,
    output reg [2:0] Q
);always @(posedge CLK) begin
        if (RST) begin
            Q <= 3'b0;
        end else if (UP && !DOWN) begin
            Q <= Q + 1;
        end else if (!UP && DOWN) begin
            Q <= Q - 1;
        end
    end

endmodule