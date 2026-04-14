module register8 (
    input wire clk,
    input wire load,
    input wire [7:0] d,
    output reg [7:0] q
);

    always @(posedge clk) begin
        if (load) begin
            q <= d;
        end
    end

endmodule