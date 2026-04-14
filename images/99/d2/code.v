module top_module(
    input CLK,
    input RESET,
    input LOAD,
    input [3:0] DATA,
    output reg [3:0] Q
);always @(posedge CLK) begin
        if (RESET) begin
            Q <= 4'b0000;
        end else if (LOAD) begin
            Q <= DATA;
        end else begin
            if (Q == 4'b1001) begin
                Q <= 4'b0000;
            end else begin
                Q <= Q + 1;
            end
        end
    end

endmodule