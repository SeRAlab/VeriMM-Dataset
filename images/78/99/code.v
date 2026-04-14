module top_module(
    input CLK,
    input RST,
    input DIR,
    output reg [3:0] Q
);always @(posedge CLK or posedge RST) begin
        if (RST) begin
            Q <= 4'b0000;
        end
        else begin
            if (DIR == 1'b0) begin
                Q <= Q + 1;
            end
            else begin
                Q <= Q - 1;
            end
        end
    end

endmodule