module top_module(
    input CLK, RST, LD, UD,
    input [3:0] LOAD_IN,
    output reg [3:0] Q
);always @(posedge CLK) begin
        if (RST) begin
            Q <= 4'b0;
        end else if (LD) begin
            Q <= LOAD_IN;
        end else if (UD) begin
            Q <= Q + 1;
        end else begin
            Q <= Q - 1;
        end
    end

endmodule