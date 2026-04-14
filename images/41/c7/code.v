module top_module(
    input [3:0] LOAD,
    input UP_DOWN,
    input CLK,
    input RESET,
    output reg [3:0] COUNT
);always @(posedge CLK or posedge RESET) begin
        if (RESET) begin
            COUNT <= 4'b0;
        end
        else if (LOAD) begin
            COUNT <= LOAD;
        end
        else if (UP_DOWN) begin
            COUNT <= COUNT + 1;
        end
        else begin
            COUNT <= COUNT - 1;
        end
    end

endmodule