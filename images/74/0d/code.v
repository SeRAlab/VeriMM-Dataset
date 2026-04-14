module register (
    input [7:0] d,
    input clk,
    input load,
    output reg [7:0] q
);

    always @(posedge clk) begin
        if (load) begin
            q <= d;
        end
    end

endmodule