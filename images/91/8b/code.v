module top_module(
    input CLK,
    input RST,
    input UP_DOWN,
    output reg [3:0] Q
);always @(posedge CLK) begin
        if (RST) begin
            Q <= 4'b0000;
        end else begin
            if (UP_DOWN) begin
                Q <= Q + 4'b0001;
            end else begin
                Q <= Q - 4'b0001;
            end
        end
    end

endmodule