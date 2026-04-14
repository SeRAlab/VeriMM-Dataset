module register (
    input clk,
    input rst,
    input load,
    input [15:0] d,
    output reg [15:0] q
);

    always @(posedge clk) begin
        if (rst) begin
            q <= 16'd0;
        end else if (load) begin
            q <= d;
        end
    end

endmodule