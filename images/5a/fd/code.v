module register (
    input clk,
    input load,
    input reset,
    input [7:0] data,
    output reg [7:0] q
);

    always @(posedge clk) begin
        if (reset)
            q <= 8'b00000000;
        else if (load)
            q <= data;
    end

endmodule