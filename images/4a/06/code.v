module reg4 (
    input wire clk,
    input wire load,
    input wire [3:0] d,
    output reg [3:0] q
);

    always @(posedge clk) begin
        if (load) begin
            q <= d;
        end
    end

endmodule