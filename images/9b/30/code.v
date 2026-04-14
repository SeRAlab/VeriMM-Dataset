module top_module(
    input CLK,
    input UD,
    output reg [3:0] Q
);always @(posedge CLK) begin
        if (UD == 1'b0) begin
            if (Q == 4'b1111) begin
                Q <= 4'b0000;
            end else begin
                Q <= Q + 1;
            end
        end else begin
            if (Q == 4'b0000) begin
                Q <= 4'b1111;
            end else begin
                Q <= Q - 1;
            end
        end
    end

endmodule