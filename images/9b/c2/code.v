module reg8 (
        input clk,
        input reset,
        input load,
        input [7:0] d,
        output reg [7:0] q);

    always @(posedge clk or posedge reset) begin
        if (reset)
            q <= 8'b00000000;
        else if (load)
            q <= d;
    end

endmodule