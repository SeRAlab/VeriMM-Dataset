module top_module(
    input CLK, UP_DOWN, RESET,
    output reg [3:0] Q
);always @(posedge CLK) begin
        if(RESET) begin
            Q <= 4'b0000;
        end
        else begin
            if(UP_DOWN) begin
                Q <= Q + 1;
            end
            else begin
                Q <= Q - 1;
            end
        end
    end

endmodule