module reg16(
    input clk,
    input load,
    input [15:0] d,
    output reg [15:0] q
    );

    always @(posedge clk) begin
        if (load) begin
            q <= d;
        end
    end
endmodule